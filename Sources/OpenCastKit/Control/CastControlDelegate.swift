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
    
    func castControl(_ client: CastControl, deviceStatusDidChange status: CastStatus)
    
    func castControl(_ client: CastControl, mediaStatusDidChange status: CastMediaStatus)
}

public extension CastControlDelegate {
    func castControl(_ client: CastControl, didConnectTo device: CastDevice) {}
    
    func castControl(_ client: CastControl, didDisconnectFrom device: CastDevice) {}
    
    func castControl(_ client: CastControl, deviceStatusDidChange status: CastStatus) {}
    
    func castControl(_ client: CastControl, mediaStatusDidChange status: CastMediaStatus) {}
}
