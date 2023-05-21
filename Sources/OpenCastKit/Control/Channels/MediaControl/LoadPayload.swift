//
//  LoadPayload.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public struct CastMedia {
    public init(activeTrackIds: [Int]? = nil, autoplay: Bool, credentials: String? = nil, credentialsType: String? = nil, currentTime: Double, loadOptions: LoadOptions? = nil, media: MediaInformation? = nil, mediaSessionId: Int? = nil, playbackRate: Double? = nil, queueData: QueueData? = nil) {
        self.activeTrackIds = activeTrackIds
        self.autoplay = autoplay
        self.credentials = credentials
        self.credentialsType = credentialsType
        self.currentTime = currentTime
        self.loadOptions = loadOptions
        self.media = media
        self.mediaSessionId = mediaSessionId
        self.playbackRate = playbackRate
        self.queueData = queueData
    }
    
    let activeTrackIds: [Int]?
    let autoplay: Bool
    let credentials: String?
    let credentialsType: String?
    let currentTime: Double
    let loadOptions: LoadOptions?
    let media: MediaInformation?
    let mediaSessionId: Int?
    let playbackRate: Double?
    let queueData: QueueData?
}

struct LoadPayload: CastJSONPayload {
    var requestId: Int?
    let type = "LOAD"
    let sessionId: String
    let activeTrackIds: [Int]?
    let autoplay: Bool
    let credentials: String?
    let credentialsType: String?
    let currentTime: Double
    let loadOptions: LoadOptions?
    let media: MediaInformation?
    let mediaSessionId: Int?
    let playbackRate: Double?
    let queueData: QueueData?
}
