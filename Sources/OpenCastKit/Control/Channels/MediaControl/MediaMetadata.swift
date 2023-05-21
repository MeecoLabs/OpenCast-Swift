//
//  MediaMetadata.swift
//
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public struct MediaMetadata: Codable {
    public init(metadataType: MetadataType? = nil, posterUrl: String? = nil, queueItemId: Int? = nil, sectionDuration: Int? = nil, sectionStartAbsoluteTime: Int? = nil, sectionStartTimeInContainer: Int? = nil, sectionStartTimeInMedia: Int? = nil) {
        self.metadataType = metadataType
        self.posterUrl = posterUrl
        self.queueItemId = queueItemId
        self.sectionDuration = sectionDuration
        self.sectionStartAbsoluteTime = sectionStartAbsoluteTime
        self.sectionStartTimeInContainer = sectionStartTimeInContainer
        self.sectionStartTimeInMedia = sectionStartTimeInMedia
    }
    
    let metadataType: MetadataType?
    let posterUrl: String?
    let queueItemId: Int?
    let sectionDuration: Int?
    let sectionStartAbsoluteTime: Int?
    let sectionStartTimeInContainer: Int?
    let sectionStartTimeInMedia: Int?
}
