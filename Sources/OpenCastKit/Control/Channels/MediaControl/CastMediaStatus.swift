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

extension MediaTrack {
    init(json: NSDictionary) {
        self.isInband = json["isInband"] as! Bool
        self.trackId = json["trackId"] as! Int
        self.trackContentId = json["trackContentId"] as! String
        self.language = json["language"] as! String
        self.subtype = json["subtype"] as! String
        self.type = json["type"] as! String
        self.trackContentType = json["trackContentType"] as! String
        self.name = json["name"] as! String
    }
}

public struct MediaStatusMedia: Codable, Equatable {
    public let tracks: [MediaTrack]
}

extension MediaStatusMedia {
    init(json: NSDictionary) {
        let tracks = json["tracks"] as! [NSDictionary]
        self.tracks = tracks.map({ MediaTrack(json: $0) })
    }
}

public struct ExtendedMediaStatus: Codable, Equatable {
    public let playerState: String // LOADING
    public let media: MediaStatusMedia
    public let contentId: String
    public let contentType: String
    public let streamType: String // BUFFERED
    public let mediaCategory: String // VIDEO
}

extension ExtendedMediaStatus {
    init(json: NSDictionary) {
        self.playerState = json["playerState"] as! String
        let media = json["media"] as! NSDictionary
        self.media = MediaStatusMedia(json: media)
        self.contentId = json["contentId"] as! String
        self.contentType = json["contentType"] as! String
        self.streamType = json["streamType"] as! String
        self.mediaCategory = json["mediaCategory"] as! String
    }
}

public struct CastMediaStatus: Codable, Equatable {
    public let mediaSessionId: Int
//    public let playbackRate: Float
    public let playerState: String // IDLE, BUFFERING, PLAYING, PAUSED
//    public let currentTime: Float
//    public let supportedMediaCommands: Int
//    public let volume: SetVolume
//    public let activeTrackIds: [Int]?
//    public let currentItemId: Int
//    public let idleReason: String?
//    public let extendedStatus: ExtendedMediaStatus?
//    public let repeatMode: RepeatMode?
}

extension CastMediaStatus {
    init(json: NSDictionary) {
        self.mediaSessionId = json["mediaSessionId"] as! Int
//        self.playbackRate = (json["playbackRate"] as! NSNumber).floatValue
        self.playerState = json["playerState"] as! String
//        self.currentTime = (json["currentTime"] as! NSNumber).floatValue
//        self.supportedMediaCommands = json["supportedMediaCommands"] as! Int
//        let volume = json["volume"] as! NSDictionary
//        self.volume = SetVolume(json: volume)
//        self.activeTrackIds = json["activeTrackIds"] as? [Int]
//        self.currentItemId = json["currentItemId"] as! Int
//        self.idleReason = json["idleReason"] as? String
//        if let extendedStatus = json["extendedStatus"] as? NSDictionary {
//            self.extendedStatus = ExtendedMediaStatus(json: extendedStatus)
//        } else {
//            self.extendedStatus = nil
//        }
//        if let repeatMode = json["repeatMode"] as? String {
//            self.repeatMode = RepeatMode(rawValue: repeatMode)!
//        } else {
//            self.repeatMode = nil
//        }
    }
}
