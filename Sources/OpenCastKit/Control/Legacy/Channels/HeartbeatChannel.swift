//
//  HeartbeatChannel.swift
//  Caster
//
//  Created by Dustin Steiner on 17/02/2023.
//

import Foundation

private let Namespace = "urn:x-cast:com.google.cast.tp.heartbeat"

protocol HeartbeatChannelDelegate: AnyObject {
    func channelDidConnect(_ channel: HeartbeatChannel)
    func channelDidTimeout(_ channel: HeartbeatChannel)
}

class HeartbeatChannel: CastChannel {
    private var timer: Timer?
    
    override weak var requestDispatcher: RequestDispatchable! {
        didSet {
            if requestDispatcher != nil {
                startBeating()
            } else {
                timer?.invalidate()
            }
        }
    }
    
    private var delegate: HeartbeatChannelDelegate? {
        return requestDispatcher as? HeartbeatChannelDelegate
    }
    
    init() {
        super.init(namespace: Namespace)
    }
    
    override func handleResponse(_ json: NSDictionary, sourceId: String) {
        delegate?.channelDidConnect(self)
        
        guard let rawType = json["type"] as? String else {
            return
        }
        
        if rawType == "PING" {
            print("HeartbeatChannel.handleResponse: PING from \(sourceId)")
            sendPong(to: sourceId)
        }
    }
    
    private func startBeating() {
        print("HeartbeatChannel.startTimer")
        DispatchQueue.global(qos: .background).async {
            let timer = Timer(timeInterval: 5, repeats: true) { _ in
                self.sendPing()
            }
            self.timer = timer
            let runLoop = RunLoop.current
            runLoop.add(timer, forMode: .default)
            runLoop.run()
        }
        sendPing()
    }
    
    private func sendPing() {
        print("HeartbeatChannel.sendPing")
        let request = requestDispatcher.request(withNamespace: namespace,
                                                destinationId: CastConstants.transport,
                                                payload: HeartbeatPingPayload())
            
        send(request)
    }
    
    private func sendPong(to destinationId: String) {
        print("HeartbeatChannel.sendPong")
        let request = requestDispatcher.request(withNamespace: namespace,
                                                destinationId: destinationId,
                                                payload: HeartbeatPongPayload())
            
        send(request)
    }
}
