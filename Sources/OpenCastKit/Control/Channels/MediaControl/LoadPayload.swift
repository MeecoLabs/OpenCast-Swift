//
//  LoadPayload.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public struct CastMedia {
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
