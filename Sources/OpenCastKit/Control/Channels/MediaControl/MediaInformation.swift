//
//  MediaInformation.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public struct MediaInformation: Codable {
    let breakClips: [BreakClip]?
    let breaks: [Break]?
    let contentId: String
    let contentType: String
    let contentUrl: String?
    let duration: Int?
    let entity: String?
    let hlsSegmentFormat: HlsSegmentFormat?
    let hlsVideoSegmentFormat: HlsVideoSegmentFormat?
    let mediaCategory: MediaCategory?
    let metadata: MediaMetadata?
    let startAbsoluteTime: Int?
    let streamType: StreamType?
    let textTrackStyle: TextTrackStyle?
    let tracks: [Track]?
    let userActionStates: [UserActionState]?
    let vmapAdsRequest: VastAdsRequest?
}
