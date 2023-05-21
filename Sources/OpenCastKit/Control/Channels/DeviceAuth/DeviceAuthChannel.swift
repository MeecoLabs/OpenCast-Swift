//
//  DeviceAuthChannel.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

// Technically not required since this is not being used anywhere but added for completion
private let Namespace = "urn:x-cast:com.google.cast.tp.connection"

// TODO: turn this public once it has implemented
private class DeviceAuthChannel: CastChannel {
    public init() {
        super.init(namespace: Namespace)
    }
    
    public func sendAuthChallenge() {
        print("DeviceAuthChannel: sendAuthChallenge")
        // TODO
    }
}
