//
//  CastClientDelegate.swift
//  Caster
//
//  Created by Dustin Steiner on 17/02/2023.
//

import Foundation

public protocol CastClientDelegate: AnyObject {
    func castClient(_ client: CastClient, didConnectTo device: CastDevice)
    
    func castClient(_ client: CastClient, didDisconnectFrom device: CastDevice)
}

public extension CastClientDelegate {
    func castClient(_ client: CastClient, didConnectTo device: CastDevice) {}
    
    func castClient(_ client: CastClient, didDisconnectFrom device: CastDevice) {}
}
