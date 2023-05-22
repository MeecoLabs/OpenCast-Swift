//
//  CastControl.swift
//  
//
//  Created by Dustin Steiner on 24.04.23.
//

import Foundation
import Network

public class CastControl: RequestDispatchable, Channelable {
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()
    
    private let device: CastDevice
    private var connection: NWConnection?
    
    public weak var delegate: CastControlDelegate?
    
    public private(set) var connectedApp: ReceiverApp? {
        didSet {
            if oldValue != connectedApp {
                let app = connectedApp
                DispatchQueue.main.async {
                    self.delegate?.castControl(self, activeAppDidChange: app)
                }
            }
        }
    }
    
    public private(set) var currentStatus: ReceiverStatus? {
        didSet {
            guard let status = currentStatus else {
                return
            }
         
            if oldValue != status {
                DispatchQueue.main.async {
                    self.delegate?.castControl(self, deviceStatusDidChange: status)
                }
            }
        }
    }
    
    public private(set) var currentMediaStatus: CastMediaStatus? {
        didSet {
            if oldValue != currentMediaStatus {
                let status = currentMediaStatus
                DispatchQueue.main.async {
                    self.delegate?.castControl(self, mediaStatusDidChange: status)
                }
            }
        }
    }
    
    private let senderName: String = "sender-\(UUID().uuidString)"
    internal var channels = [String: CastChannel]()
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
        print("CastClient.receive")
        let data = Data()
        self.receiveMore(data)
    }
    
    private func receiveMore(_ buffer: Data) {
        print("CastClient.receiveMore")
        connection?.receiveDiscontiguous(minimumIncompleteLength: 1, maximumLength: 16 * 1024, completion: { data, contentContext, isComplete, error in
            if let error {
                print("CastClient.receiveMore: error = \(error)")
                self.receive()
            } else if let data {
                print("CastClient.receiveMore: received")
                do {
                    let data = buffer + Data(data)
                    if !isComplete {
                        self.receiveMore(data)
                    } else {
                        try self.processReceived(data)
                        self.receive()
                    }
                } catch {
                    print("CastClient.receiveMore: error = \(error)")
                    self.receive()
                }
            }
        })
    }
    
    private func processReceived(_ data: Data) throws {
        print("CastClient.processReceived")
        let headerSize = MemoryLayout<UInt32>.size
        let header = data.withUnsafeBytes { $0.load(as: UInt32.self) }
        let payloadSize = Int(CFSwapInt32BigToHost(header))
        // TODO: data will have a maximum size of 16 * 1024 so the payload size might be too large sometimes, so we need to combine iterations
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
    
    private lazy var mediaControlChannel: MediaControlChannel = {
      let channel = MediaControlChannel()
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
    
    public func join(app: ReceiverApp?, completion: @escaping (Result<ReceiverApp, CastError>) -> Void) {
        guard let target = app ?? currentStatus?.applications?.first else {
            completion(Result.failure(CastError.session("No apps running")))
            return
        }
        
        if target == connectedApp {
            completion(Result.success(target))
        } else if let existing = currentStatus?.applications?.first(where: { $0.appId == target.appId }) {
            connect(to: existing)
            completion(Result.success(existing))
        } else {
            receiverControlChannel.requestStatus { [weak self] result in
                switch result {
                    case .success(let status):
                        guard let app = status.applications?.first else {
                            completion(Result.failure(CastError.launch("Unable to get launched app instance")))
                            return
                        }
                 
                        self?.connect(to: app)
                        completion(Result.success(app))
                 
                    case .failure(let error):
                        completion(Result.failure(error))
                }
            }
        }
    }
    
    public func launch(appId: String, completion: @escaping (Result<ReceiverApp, CastError>) -> Void) {
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
    
    public func stopCurrentApp() {
        guard let app = currentStatus?.applications?.first else {
            return
        }
      
      receiverControlChannel.stop(app: app)
    }
    
    public func leave(_ app: ReceiverApp) {
        connectionChannel.leave(app)
        connectedApp = nil
    }
    
    public func load(media: CastMedia, with app: ReceiverApp, completion: @escaping (Result<[CastMediaStatus], CastError>) -> Void) {
        mediaControlChannel.load(media: media, with: app, completion: completion)
    }
    
    public func requestMediaStatus(for app: ReceiverApp, completion: ((Result<[CastMediaStatus], CastError>) -> Void)? = nil) {
        mediaControlChannel.requestMediaStatus(for: app)
    }
    
    private func connect(to app: ReceiverApp) {
        connectionChannel.connect(to: app)
        connectedApp = app
    }
    
    public func pause() {
        guard let app = connectedApp else {
            return
        }
      
        if let mediaStatus = currentMediaStatus {
            mediaControlChannel.sendPause(for: app, mediaSessionId: mediaStatus.mediaSessionId)
        } else {
            mediaControlChannel.requestMediaStatus(for: app) { result in
              switch result {
                  case .success(let mediaStatus):
                      if let mediaSessionId = mediaStatus.first?.mediaSessionId {
                          self.mediaControlChannel.sendPause(for: app, mediaSessionId: mediaSessionId)
                      }
                  
                  case .failure(let error):
                      print(error)
                }
            }
        }
    }
    
    public func play() {
        guard let app = connectedApp else {
            return
        }
      
        if let mediaStatus = currentMediaStatus {
            mediaControlChannel.sendPlay(for: app, mediaSessionId: mediaStatus.mediaSessionId)
        } else {
            mediaControlChannel.requestMediaStatus(for: app) { result in
                switch result {
                    case .success(let mediaStatus):
                        if let mediaSessionId = mediaStatus.first?.mediaSessionId {
                            self.mediaControlChannel.sendPlay(for: app, mediaSessionId: mediaSessionId)
                        }
            
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    
    public func stop() {
        guard let app = connectedApp else {
            return
        }
      
        if let mediaStatus = currentMediaStatus {
            mediaControlChannel.sendStop(for: app, mediaSessionId: mediaStatus.mediaSessionId)
        } else {
            mediaControlChannel.requestMediaStatus(for: app) { result in
                switch result {
                    case .success(let mediaStatus):
                        if let mediaSessionId = mediaStatus.first?.mediaSessionId {
                            self.mediaControlChannel.sendStop(for: app, mediaSessionId: mediaSessionId)
                        }
            
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    
    public func seek(to currentTime: Float) {
        guard let app = connectedApp else {
            return
        }
      
        if let mediaStatus = currentMediaStatus {
            mediaControlChannel.sendSeek(to: currentTime, for: app, mediaSessionId: mediaStatus.mediaSessionId)
        } else {
            mediaControlChannel.requestMediaStatus(for: app) { result in
                switch result {
                    case .success(let mediaStatus):
                        if let mediaSessionId = mediaStatus.first?.mediaSessionId {
                            self.mediaControlChannel.sendSeek(to: currentTime, for: app, mediaSessionId: mediaSessionId)
                        }
            
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    
    public func editTracksInformation(activeTrackIds: [Int]?, textTrackStyle: TextTrackStyle?, for app: ReceiverApp) {
        guard let app = connectedApp else {
            return
        }
      
        if let mediaStatus = currentMediaStatus {
            mediaControlChannel.editTracksInformation(activeTrackIds: activeTrackIds, textTrackStyle: textTrackStyle, for: app, mediaSessionId: mediaStatus.mediaSessionId)
        } else {
            mediaControlChannel.requestMediaStatus(for: app) { result in
                switch result {
                    case .success(let mediaStatus):
                        if let mediaSessionId = mediaStatus.first?.mediaSessionId {
                            self.mediaControlChannel.editTracksInformation(activeTrackIds: activeTrackIds, textTrackStyle: textTrackStyle, for: app, mediaSessionId: mediaSessionId)
                        }
            
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    
    public func setVolume(_ volume: Float) {
        receiverControlChannel.setVolume(volume)
    }
    
    public func setMuted(_ muted: Bool) {
        receiverControlChannel.setMuted(muted)
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
        currentStatus = nil
        currentMediaStatus = nil
        connectedApp = nil
    }
}

extension CastControl: ReceiverControlChannelDelegate {
    func channel(_ channel: ReceiverControlChannel, didReceive status: ReceiverStatus) {
        currentStatus = status
    }
}

extension CastControl: MediaControlChannelDelegate {
    func channel(_ channel: MediaControlChannel, didReceive mediaStatus: [CastMediaStatus]) {
        currentMediaStatus = mediaStatus.first
    }
}
