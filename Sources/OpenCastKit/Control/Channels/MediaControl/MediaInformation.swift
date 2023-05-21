//
//  MediaInformation.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public struct MediaInformation: Codable {
    public init(breakClips: [BreakClip]? = nil, breaks: [Break]? = nil, contentId: String, contentType: String, contentUrl: String? = nil, duration: Int? = nil, entity: String? = nil, hlsSegmentFormat: HlsSegmentFormat? = nil, hlsVideoSegmentFormat: HlsVideoSegmentFormat? = nil, mediaCategory: MediaCategory? = nil, metadata: MediaMetadata? = nil, startAbsoluteTime: Int? = nil, streamType: StreamType? = nil, textTrackStyle: TextTrackStyle? = nil, tracks: [Track]? = nil, userActionStates: [UserActionState]? = nil, vmapAdsRequest: VastAdsRequest? = nil) {
        self.breakClips = breakClips
        self.breaks = breaks
        self.contentId = contentId
        self.contentType = contentType
        self.contentUrl = contentUrl
        self.duration = duration
        self.entity = entity
        self.hlsSegmentFormat = hlsSegmentFormat
        self.hlsVideoSegmentFormat = hlsVideoSegmentFormat
        self.mediaCategory = mediaCategory
        self.metadata = metadata
        self.startAbsoluteTime = startAbsoluteTime
        self.streamType = streamType
        self.textTrackStyle = textTrackStyle
        self.tracks = tracks
        self.userActionStates = userActionStates
        self.vmapAdsRequest = vmapAdsRequest
    }
    
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
