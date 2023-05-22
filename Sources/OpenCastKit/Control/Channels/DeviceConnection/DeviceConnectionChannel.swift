//
//  DeviceConnectionChannel.swift
//  
//
//  Created by Dustin Steiner on 17/02/2023.
//

import Foundation

private let Namespace = "urn:x-cast:com.google.cast.tp.connection"

class DeviceConnectionChannel: CastChannel {
    override weak var requestDispatcher: RequestDispatchable! {
        didSet {
            if requestDispatcher != nil {
                connect()
            }
        }
    }
    
    init() {
        super.init(namespace: Namespace)
    }
    
    private func connect() {
        print("DeviceConnectionChannel: connect")
        let request = requestDispatcher.request(withNamespace: namespace,
                                                destinationId: CastConstants.receiver,
                                                payload: DeviceConnectPayload())
            
        send(request)
    }
    
    public func connect(to app: ReceiverApp) {
        print("DeviceConnectionChannel: connect to \(app)")
        let request = requestDispatcher.request(withNamespace: namespace,
                                                destinationId: app.transportId,
                                                payload: DeviceConnectPayload())
            
        send(request)
    }
    
    public func leave(_ app: ReceiverApp) {
        print("DeviceConnectionChannel: connect to \(app)")
        let request = requestDispatcher.request(withNamespace: namespace,
                                                destinationId: app.transportId,
                                                payload: DeviceDisconnectPayload())
        
        send(request)
    }
}
