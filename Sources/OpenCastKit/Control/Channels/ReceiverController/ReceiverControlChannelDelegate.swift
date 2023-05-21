//
//  ReceiverControlChannelDelegate.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

protocol ReceiverControlChannelDelegate: AnyObject {
    func channel(_ channel: ReceiverControlChannel, didReceive status: CastStatus)
}
