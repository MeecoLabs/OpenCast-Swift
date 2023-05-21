//
//  Caster.swift
//  Caster
//
//  Created by Dustin Steiner on 15/02/2023.
//

import Foundation
import Network

//struct Origin: Codable {
//}
//
//struct SenderInfo: Encodable {
//    let sdkType = 2
//    let version = "15.605.1.3"
//    let browserVersion = "44.0.2403.30"
//    let platform = 4
//    let systemVersion = "Macintosh; Intel Mac OS X10_10_3"
//    let connectionType = 1
//}
//
//struct ConnectJsonMessage: Encodable {
//    let type = "CONNECT"
//    let requestId: Int
////    let origin = Origin()
////    let userAgent = "Caster"
////    let senderInfo = SenderInfo()
//}
//
//struct PingJsonMessage: Encodable {
//    let type = "PING"
//    let requestId: Int
//}
//
//struct GetStatusJsonMessage: Encodable {
//    let type = "GET_STATUS"
//    let requestId: Int
//}
//
//enum ChannelError: Error {
//    case notConnected
//    case invalidString
//}
//
//class Channel {
//    private let encoder = JSONEncoder()
//    
//    private let device: CastDevice
//    private var connection: NWConnection?
//    private var pingPongTimer: Timer?
//    private var currentRequestId = 0
//    
//    init(device: CastDevice) {
//        self.device = device
//        
//        connection = createConnection()
//    }
//    
//    private func createConnection() -> NWConnection {
//        let connection = NWConnection(to: device.endpoint, using: createTLSParameters(allowInsecure: true, queue: .global(qos: .background)))
//        connection.stateUpdateHandler = self.handleConnectionStateUpate
//        return connection
//    }
//    
//    private func createTLSParameters(allowInsecure: Bool, queue: DispatchQueue) -> NWParameters {
//        let options = NWProtocolTLS.Options()
//        sec_protocol_options_set_verify_block(options.securityProtocolOptions, { sec_protocol_metadata, sec_trust, sec_protocol_verify_complete in
//            let trust = sec_trust_copy_ref(sec_trust).takeRetainedValue()
//            var error: CFError?
//            if SecTrustEvaluateWithError(trust, &error) {
//                sec_protocol_verify_complete(true)
//            } else {
//                sec_protocol_verify_complete(allowInsecure)
//            }
//        }, queue)
//        return NWParameters(tls: options)
//    }
//    
//    func connect() {
//        print("Channel.connect")
//        if connection == nil {
//            connection = createConnection()
//        } else {
//            pingPongTimer?.invalidate()
//        }
//        
//        connection?.start(queue: .global(qos: .background))
//    }
//    
//    func disconnect() {
//        print("Channel.disconnect")
//        pingPongTimer?.invalidate()
//        pingPongTimer = nil
//        connection?.cancel()
//        connection = nil
//    }
//    
//    private func handleConnectionStateUpate(_ state: NWConnection.State) {
//        print("Channel.handleConnectionStateUpate: state = \(state)")
//        switch state {
//            case .ready:
//                handleConnected()
//                startReceiving()
//                
//            default:
//                break
//        }
//    }
//    
//    private func handleConnected() {
//        print("Channel.handleConnected")
//        Task(priority: .background) {
//            do {
////                try await authenticate()
//                try await sendConnect()
//                try await sendStatusRequest()
//                try await sendPing()
//                self.startPingPong()
//            } catch {
//                self.disconnect()
//            }
//        }
//    }
//    
//    private func startReceiving() {
//        Task {
//            try receive(completion: { message, error in
//                if let error {
//                    print("RECEIVE FAILED \(error)")
//                } else {
//                    print("RECEIVED \(message)")
//                }
//                self.startReceiving()
//            })
//        }
//    }
//    
//    private func startPingPong() {
//        print("startPingPong")
//        pingPongTimer?.invalidate()
//        
//        pingPongTimer = Timer(timeInterval: 5.0, repeats: true, block: { _ in
//            print("PING")
//            Task {
//                try await self.sendPing()
//            }
//        })
//        if let pingPongTimer {
//            DispatchQueue.global(qos: .background).async {
//                RunLoop.current.add(pingPongTimer, forMode: .default)
//                RunLoop.current.run()
//            }
//        }
//    }
//    
//    private func authenticate() async throws {
//        print("Channel.authenticate")
//        do {
//            let payload = try buildAuthChallengeMessage()
//            let message = try buildCastMessage(namespace: "urn:x-cast:com.google.cast.tp.deviceauth", destinationId: "receiver-0", payload: payload)
//            try await send(message: message)
////            let authData = try await receive()
////            print("authData = \(authData?.hexEncodedString() ?? "nil")")
//        } catch {
//            print("Channel.authenticate: error = \(error)")
//            throw error
//        }
//    }
//    
//    private func sendConnect() async throws {
//        print("Channel.sendConnect")
//        do {
//            
//            let payload = ConnectJsonMessage(requestId: nextRequestId())
//            let message = try buildCastMessage(namespace: "urn:x-cast:com.google.cast.tp.connection", destinationId: "receiver-0", payload: payload)
//            try await send(message: message)
////            let authData = try await receive()
////            print("connect data = \(authData?.hexEncodedString() ?? "nil")")
//        } catch {
//            print("Channel.authenticate: error = \(error)")
//            throw error
//        }
//    }
//    
//    private func sendPing() async throws {
//        print("Channel.sendPing")
//        do {
//            
//            let payload = PingJsonMessage(requestId: nextRequestId())
//            let message = try buildCastMessage(namespace: "urn:x-cast:com.google.cast.tp.heartbeat", destinationId: "transport-0", payload: payload)
//            try await send(message: message)
////            let authData = try await receive()
////            print("connect data = \(authData?.hexEncodedString() ?? "nil")")
//        } catch {
//            print("Channel.authenticate: error = \(error)")
//            throw error
//        }
//    }
//    
//    private func sendStatusRequest() async throws {
//        print("Channel.sendStatusRequest")
//        do {
//            
//            let payload = GetStatusJsonMessage(requestId: nextRequestId())
//            let message = try buildCastMessage(namespace: "urn:x-cast:com.google.cast.receiver", destinationId: "receiver-0", payload: payload)
//            try await send(message: message)
//            let received = try await receive()
//            print("connect data = \(received)")
//        } catch {
//            print("Channel.authenticate: error = \(error)")
//            throw error
//        }
//    }
//    
//    private func nextRequestId() -> Int {
//        currentRequestId += 1
//        return currentRequestId
//    }
//    
//    private func buildAuthChallengeMessage() throws -> Data {
//        let payload = Cast_Channel_AuthChallenge.with {
//            $0.signatureAlgorithm = .unspecified
//            $0.senderNonce = "12345".data(using: .utf8)!
//            $0.hashAlgorithm = .sha256
//        }
//        return try payload.serializedData()
//    }
//    
//    private func buildCastMessage(namespace: String, destinationId: String, payload codable: Encodable) throws -> Data {
//        let data = try encoder.encode(codable)
//        guard let string = String(data: data, encoding: .utf8) else {
//            throw ChannelError.invalidString
//        }
//        let message = Cast_Channel_CastMessage.with {
//            $0.protocolVersion = .castv210
//            $0.sourceID = "sender-\(UUID().uuidString)"
//            $0.destinationID = destinationId
//            $0.namespace = namespace
//            $0.payloadType = .string
//            print("MESSAGE \(string)")
//            $0.payloadUtf8 = string
//        }
//        return wrapWithHeader(try message.serializedData())
//    }
//    
//    private func buildCastMessage(namespace: String, destinationId: String, payload data: Data) throws -> Data {
//        let message = Cast_Channel_CastMessage.with {
//            $0.protocolVersion = .castv210
//            $0.sourceID = "sender-\(UUID().uuidString)"
//            $0.destinationID = destinationId
//            $0.namespace = namespace
//            $0.payloadType = .binary
//            $0.payloadBinary = data
//        }
//        return wrapWithHeader(try message.serializedData())
//    }
//    
//    private func wrapWithHeader(_ data: Data) -> Data {
//        var payloadSize = UInt32(data.count).bigEndian
//        let packet = NSMutableData(bytes: &payloadSize, length: MemoryLayout<UInt32>.size)
//        packet.append(data)
//        return Data(packet)
//    }
//    
//    private func send(message: Data, completion: @escaping (Error?) -> Void) throws {
//        print("Channel.send: \(try Cast_Channel_CastMessage(serializedData: message[4...]))")
//        guard let connection else {
//            throw ChannelError.notConnected
//        }
//        
//        connection.send(content: message, isComplete: true, completion: .contentProcessed({ error in
//            if let error {
//                return completion(error)
//            }
//            
//            completion(nil)
//        }))
//    }
//    
//    private func send(message: Data) async throws {
//        return try await withCheckedThrowingContinuation({ continuation in
//            do {
//                try send(message: message, completion: { error in
//                    if let error {
//                        return continuation.resume(throwing: error)
//                    }
//                    
//                    continuation.resume()
//                })
//            } catch {
//                return continuation.resume(throwing: error)
//            }
//        })
//    }
//    
//    private func receive(completion: @escaping (Cast_Channel_CastMessage?, Error?) -> Void) throws {
//        print("Channel.receive")
//        guard let connection else {
//            throw ChannelError.notConnected
//        }
//        
//        connection.receiveDiscontiguous(minimumIncompleteLength: 1, maximumLength: 8192, completion: { data, context, isComplete, error in
//            if let error {
//                return completion(nil, error)
//            }
//            
//            if let data {
//                do {
//                    let data = Data(data)
//                    let message = try? Cast_Channel_CastMessage(serializedData: data[4...])
//                    if message == nil {
//                        print("EMPTY MESSAGE \(data.hexEncodedString())")
//                    }
//                    completion(message, nil)
//                } catch {
//                    completion(nil, error)
//                }
//            } else {
//                completion(nil, nil)
//            }
//        })
//    }
//    
//    private func receive() async throws -> Cast_Channel_CastMessage? {
//        return try await withCheckedThrowingContinuation({ continuation in
//            do {
//                try receive(completion: { message, error in
//                    if let error {
//                        return continuation.resume(throwing: error)
//                    }
//                    
//                    continuation.resume(returning: message)
//                })
//            } catch {
//                return continuation.resume(throwing: error)
//            }
//        })
//    }
//}
//
//class Caster: DiscoveryDelegate {
//    private let discovery = Discovery()
//    private var channel: Channel?
//    
//    init() {
//        discovery.delegate = self
//    }
//    
//    func startDiscovery() {
//        print("Caster.startDiscovery")
//        discovery.start()
//    }
//    
//    func stopDiscovery() {
//        print("Caster.stopDiscovery")
//        discovery.stop()
//    }
//    
//    func discovery(_ discovery: Discovery, didFind device: CastDevice) {
//        print("Caster.discovery didFind")
//        guard channel == nil else {
//            print("Caster.discovery didFind: error = already connected")
//            return
//        }
//        
//        channel = Channel(device: device)
//        channel?.connect()
//    }
//}
//
//extension Data {
//    struct HexEncodingOptions: OptionSet {
//        let rawValue: Int
//        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
//    }
//
//    func hexEncodedString(options: HexEncodingOptions = []) -> String {
//        let hexDigits = options.contains(.upperCase) ? "0123456789ABCDEF" : "0123456789abcdef"
//        if #available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *) {
//            let utf8Digits = Array(hexDigits.utf8)
//            return String(unsafeUninitializedCapacity: 2 * self.count) { (ptr) -> Int in
//                var p = ptr.baseAddress!
//                for byte in self {
//                    p[0] = utf8Digits[Int(byte / 16)]
//                    p[1] = utf8Digits[Int(byte % 16)]
//                    p += 2
//                }
//                return 2 * self.count
//            }
//        } else {
//            let utf16Digits = Array(hexDigits.utf16)
//            var chars: [unichar] = []
//            chars.reserveCapacity(2 * self.count)
//            for byte in self {
//                chars.append(utf16Digits[Int(byte / 16)])
//                chars.append(utf16Digits[Int(byte % 16)])
//            }
//            return String(utf16CodeUnits: chars, count: chars.count)
//        }
//    }
//}
