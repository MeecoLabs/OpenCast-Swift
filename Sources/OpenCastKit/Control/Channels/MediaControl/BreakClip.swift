//
//  BreakClip.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public struct BreakClip: Codable {
    public init(clickThroughUrl: String? = nil, contentId: String? = nil, contentType: String? = nil, contentUrl: String? = nil, duration: Int? = nil, hlsSegmentFormat: HlsSegmentFormat? = nil, id: String, posterUrl: String? = nil, title: String? = nil, vastAdsRequest: VastAdsRequest? = nil, whenSkippable: Int? = nil) {
        self.clickThroughUrl = clickThroughUrl
        self.contentId = contentId
        self.contentType = contentType
        self.contentUrl = contentUrl
        self.duration = duration
        self.hlsSegmentFormat = hlsSegmentFormat
        self.id = id
        self.posterUrl = posterUrl
        self.title = title
        self.vastAdsRequest = vastAdsRequest
        self.whenSkippable = whenSkippable
    }
    
    let clickThroughUrl: String?
    let contentId: String?
    let contentType: String?
    let contentUrl: String?
    let duration: Int?
    let hlsSegmentFormat: HlsSegmentFormat?
    let id: String
    let posterUrl: String?
    let title: String?
    let vastAdsRequest: VastAdsRequest?
    let whenSkippable: Int?
}
