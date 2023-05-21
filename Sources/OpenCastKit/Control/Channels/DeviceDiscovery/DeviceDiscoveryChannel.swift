//
//  DeviceDiscoveryChannel.swift
//  
//
//  Created by Dustin Steiner on 22/02/2023.
//

import Foundation

private let Namespace = "urn:x-cast:com.google.cast.receiver.discovery"

public class DeviceDiscoveryChannel: CastChannel {
    public init() {
        super.init(namespace: Namespace)
    }
    
    public func requestDeviceInfo() {
        let request = requestDispatcher.request(withNamespace: namespace,
                                                destinationId: CastConstants.receiver,
                                                payload: RequestDeviceInfoPayload())
        
        send(request) { result in
          switch result {
              case .success(let json):
                  print(json)
            
              case .failure(let error):
                  print(error)
            }
        }
    }
}
