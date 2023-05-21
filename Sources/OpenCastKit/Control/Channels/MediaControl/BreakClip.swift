//
//  BreakClip.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public struct BreakClip: Codable {
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
