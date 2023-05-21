//
//  HeartbeatChannelDelegate.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

protocol HeartbeatChannelDelegate: AnyObject {
    func channelDidConnect(_ channel: HeartbeatChannel)
    func channelDidTimeout(_ channel: HeartbeatChannel)
}
