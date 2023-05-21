//
//  MediaControlChannelDelegate.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public protocol MediaControlChannelDelegate: AnyObject {
    func channel(_ channel: MediaControlChannel, didReceive mediaStatus: CastMediaStatus)
}
