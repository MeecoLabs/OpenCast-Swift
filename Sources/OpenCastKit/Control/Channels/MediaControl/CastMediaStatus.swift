//
//  CastMediaStatus.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public struct MediaTrack: Codable, Equatable {
    public let isInband: Bool
    public let trackId: Int
    public let trackContentId: String
    public let language: String
    public let subtype: String // SUBTITLES
    public let type: String // TEXT
    public let trackContentType: String
    public let name: String
}

public struct MediaStatusMedia: Codable, Equatable {
    public let tracks: [MediaTrack]
}

public struct ExtendedMediaStatus: Codable, Equatable {
    public let playerState: String // LOADING
    public let media: MediaStatusMedia
    public let contentId: String
    public let contentType: String
    public let streamType: String // BUFFERED
    public let mediaCategory: String // VIDEO
}

public struct CastMediaStatus: Codable, Equatable {
    public let mediaSessionId: Int
    public let playbackRate: Float
    public let playerState: String // IDLE, PLAYING, PAUSED
    public let currentTime: Float
    public let supportedMediaCommands: Int
    public let volume: SetVolume
    public let activeTrackIds: [Int]?
    public let currentItemId: Int
    public let idleReason: String?
    public let extendedStatus: ExtendedMediaStatus?
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
        self.activeTrackIds = json["activeTrackIds"] as? [Int]
        self.currentItemId = json["currentItemId"] as! Int
        self.idleReason = json["idleReason"] as? String
        // TODO
        self.extendedStatus = nil
        let repeatMode = json["repeatMode"] as! String
        self.repeatMode = RepeatMode(rawValue: repeatMode)!
    }
}
