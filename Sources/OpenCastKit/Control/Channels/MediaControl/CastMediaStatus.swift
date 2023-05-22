//
//  CastMediaStatus.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public struct CastMediaStatus: Codable, Equatable {
    public let mediaSessionId: Int
    public let playbackRate: Float
    public let playerState: String // PLAYING
    public let currentTime: Float
    public let supportedMediaCommands: Int
    public let volume: SetVolume
    public let activeTrackIds: [Int]
    public let currentItemId: Int
    public let repeatMode: RepeatMode
}

extension CastMediaStatus {
    init(json: NSDictionary) {
        self.mediaSessionId = json["mediaSessionId"] as! Int
        self.playbackRate = json["playbackRate"] as! Float
        self.playerState = json["playerState"] as! String
        self.currentTime = json["currentTime"] as! Float
        self.supportedMediaCommands = json["supportedMediaCommands"] as! Int
        let volume = json["volume"] as! NSDictionary
        self.volume = SetVolume(json: volume)
        self.activeTrackIds = json["activeTrackIds"] as! [Int]
        self.currentItemId = json["currentItemId"] as! Int
        let repeatMode = json["repeatMode"] as! String
        self.repeatMode = RepeatMode(rawValue: repeatMode)!
    }
}
