//
//  CastControlDelegate.swift
//  
//
//  Created by Dustin Steiner on 19.05.23.
//

import Foundation

public protocol CastControlDelegate: AnyObject {
    func castControl(_ client: CastControl, didConnectTo device: CastDevice)
    
    func castControl(_ client: CastControl, didDisconnectFrom device: CastDevice)
}

public extension CastControlDelegate {
    func castControl(_ client: CastControl, didConnectTo device: CastDevice) {}
    
    func castControl(_ client: CastControl, didDisconnectFrom device: CastDevice) {}
}
