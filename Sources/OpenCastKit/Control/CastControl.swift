//
//  CastControl.swift
//  
//
//  Created by Dustin Steiner on 24.04.23.
//

import Foundation
import Network

public class CastControl: RequestDispatchable {
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()
    
    private let device: CastDevice
    private var connection: NWConnection?
    
    public weak var delegate: CastControlDelegate?
    
    private let senderName: String = "sender-\(UUID().uuidString)"
    private var channels = [String: CastChannel]()
    private var responseHandlers = [Int: CastResponseHandler]()
    
    private lazy var currentRequestId = Int(arc4random_uniform(800))
    
    public private(set) var isConnected = false {
        didSet {
            if oldValue != isConnected {
                if isConnected {
                      DispatchQueue.main.async {
                          self.delegate?.castControl(self, didConnectTo: self.device)
                      }
                } else {
                      DispatchQueue.main.async {
                          self.delegate?.castControl(self, didDisconnectFrom: self.device)
                      }
                }
            }
        }
    }
    
    public init(device: CastDevice) {
        self.device = device
    }
    
    deinit {
        if connection != nil {
            disconnect()
        }
    }
    
    public func connect() {
        if connection != nil {
            return
        }
        
        print("CastControl.connect")
        
        connection = NWConnection(to: device.endpoint, using: createTLSParameters(allowInsecure: true, queue: .global()))
        connection!.stateUpdateHandler = self.handleConnectionStateUpdate
        connection!.start(queue: .global())
    }
    
    public func disconnect() {
        print("CastControl.disconnect")
        
        isConnected = false
        
        if connection == nil {
            return
        }
        
        channels.values.forEach(remove)
        
        connection?.cancel()
        connection = nil
    }
    
    private func createTLSParameters(allowInsecure: Bool, queue: DispatchQueue) -> NWParameters {
        let options = NWProtocolTLS.Options()
        sec_protocol_options_set_verify_block(options.securityProtocolOptions, { sec_protocol_metadata, sec_trust, sec_protocol_verify_complete in
            let trust = sec_trust_copy_ref(sec_trust).takeRetainedValue()
            var error: CFError?
            if SecTrustEvaluateWithError(trust, &error) {
                sec_protocol_verify_complete(true)
            } else {
                sec_protocol_verify_complete(allowInsecure)
            }
        }, queue)
        return NWParameters(tls: options)
    }
    
    private func handleConnectionStateUpdate(_ state: NWConnection.State) {
        print("CastClient.handleConnectionStateUpdate: state = \(state)")
        switch state {
            case .waiting(_):
                disconnect()
                
            case .failed(_):
                disconnect()
                
            case .ready:
                handleConnected()
                
            default:
                break
        }
    }
    
    private func handleConnected() {
        print("CastClient.handleConnected")
        
        _ = self.connectionChannel
        self.receive()
        _ = self.heartbeatChannel
        _ = self.receiverControlChannel
    }
    
    func nextRequestId() -> Int {
        currentRequestId += 1
        return currentRequestId
    }
    
    func request(withNamespace namespace: String, destinationId: String, payload: CastJSONPayload) -> CastRequest {
        var payload = payload
        let requestId = nextRequestId()
        payload.requestId = requestId
        
        return  CastRequest(id: requestId,
                            namespace: namespace,
                            destinationId: destinationId,
                            payload: payload)
    }
      
    func request(withNamespace namespace: String, destinationId: String, payload: Data) -> CastRequest {
        return  CastRequest(id: nextRequestId(),
                            namespace: namespace,
                            destinationId: destinationId,
                            payload: payload)
    }
    
    func send(_ request: CastRequest, response: CastResponseHandler?) {
        print("CastClient.send")
        
        if let response = response {
            responseHandlers[request.id] = response
        }
        
        do {
            let message = CastMessage.with {
                $0.protocolVersion = .castv210
                $0.sourceID = senderName
                $0.destinationID = request.destinationId
                $0.namespace = request.namespace
                switch request.payload {
                    case .data(let payload):
                        $0.payloadType = .binary
                        $0.payloadBinary = payload
                        
                    case .json(let payload):
                        guard let json = try? CastControl.encoder.encode(payload),
                              let jsonString = String(data: json, encoding: .utf8)
                        else {
                            fatalError("CastClient.send: error encoding json")
                        }
                        $0.payloadType = .string
                        $0.payloadUtf8 = jsonString
                }
            }
            
            print("CastClient.send: message = \(message)")
            let messageData = try message.serializedData()
            try write(data: messageData)
        } catch {
            print("CastClient.send: error = \(error)")
            callResponseHandler(for: request.id, with: Result.failure(.request(error.localizedDescription)))
        }
    }
    
    private func callResponseHandler(for requestId: Int, with result: Result<NSDictionary, CastError>) {
        DispatchQueue.main.async {
            if let handler = self.responseHandlers.removeValue(forKey: requestId) {
                handler(result)
            }
        }
    }
    
    private func write(data: Data) throws {
        print("CastClient.write")
        
        var payloadSize = UInt32(data.count).bigEndian
        let packet = NSMutableData(bytes: &payloadSize, length: MemoryLayout<UInt32>.size)
        packet.append(data)
            
        connection?.send(content: packet, isComplete: true, completion: .contentProcessed({ error in
            if let error {
                print("CastClient.write: error = \(error)")
                // TODO: error
                return
            }
        }))
    }
    
    private func receive() {
        connection?.receiveDiscontiguous(minimumIncompleteLength: 1, maximumLength: 16384, completion: { data, contentContext, isComplete, error in
            if let error {
                print("CastClient.receive: error = \(error)")
            } else if let data {
                do {
                    let data = Data(data)
                    print("CastClient.receive")
                    
                    let headerSize = MemoryLayout<UInt32>.size
                    let header = data.withUnsafeBytes { $0.load(as: UInt32.self) }
                    let payloadSize = Int(CFSwapInt32BigToHost(header))
                    let payload = data[headerSize..<headerSize+payloadSize]
                    let message = try CastMessage(serializedData: payload)
                    print("CastClient.receive: message = \(message)")
                    
                    if let channel = self.channels[message.namespace] {
                        switch message.payloadType {
                            case .string:
                                if let messageData = message.payloadUtf8.data(using: .utf8),
                                   let json = try JSONSerialization.jsonObject(with: messageData) as? NSDictionary {
                                    channel.handleResponse(json, sourceId: message.sourceID)
                                    
                                    if let requestId = json["requestId"] as? Int {
                                        self.callResponseHandler(for: requestId, with: Result.success(json))
                                    }
                                } else {
                                    print("CastClient.receive: unable to get UTF8 JSON data from message")
                                }
                                
                            case .binary:
                                channel.handleResponse(message.payloadBinary, sourceId: message.sourceID)
                        }
                    } else {
                      print("CastClient.receive: no channel attached for namespace \(message.namespace)")
                    }
                    
                } catch {
                    print("CastClient.receive: error = \(error)")
                }
            }
            
            self.receive()
        })
    }
    
    private lazy var connectionChannel: DeviceConnectionChannel = {
        let channel = DeviceConnectionChannel()
        self.add(channel: channel)
        return channel
    }()
    
    private lazy var heartbeatChannel: HeartbeatChannel = {
        let channel = HeartbeatChannel()
        self.add(channel: channel)
        return channel
    }()
    
    private lazy var receiverControlChannel: ReceiverControlChannel = {
      let channel = ReceiverControlChannel()
      self.add(channel: channel)
      return channel
    }()
    
    public func add(channel: CastChannel) {
        let namespace = channel.namespace
        guard channels[namespace] == nil else {
            print("CastClient.add channel: already attached for \(namespace)")
            return
        }
            
        channels[namespace] = channel
        channel.requestDispatcher = self
    }
    
    public func remove(channel: CastChannel) {
        let namespace = channel.namespace
        guard let channel = channels.removeValue(forKey: namespace) else {
            print("CastClient.remove channel: no channel attached for \(namespace)")
            return
        }
      
        channel.requestDispatcher = nil
    }
    
    public func getAppAvailability(apps: [String], completion: @escaping (Result<AppAvailability, CastError>) -> Void) {
        receiverControlChannel.getAppAvailability(apps: apps, completion: completion)
    }
    
    public func launch(appId: String, completion: @escaping (Result<CastApp, CastError>) -> Void) {
        receiverControlChannel.launch(appId: appId) { [weak self] result in
            switch result {
                case .success(let app):
                    self?.connect(to: app)
                    fallthrough
                
                default:
                    completion(result)
            }
        }
    }
    
    private func connect(to app: CastApp) {
        connectionChannel.connect(to: app)
    }
}

extension CastControl: HeartbeatChannelDelegate {
    func channelDidConnect(_ channel: HeartbeatChannel) {
        if !isConnected {
            isConnected = true
        }
    }
    
    func channelDidTimeout(_ channel: HeartbeatChannel) {
        disconnect()
    }
}
