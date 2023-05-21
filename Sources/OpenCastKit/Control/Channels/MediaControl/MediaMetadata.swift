//
//  MediaMetadata.swift
//
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

struct MediaMetadata: Codable {
    let metadataType: MetadataType?
    let posterUrl: String?
    let queueItemId: Int?
    let sectionDuration: Int?
    let sectionStartAbsoluteTime: Int?
    let sectionStartTimeInContainer: Int?
    let sectionStartTimeInMedia: Int?
}
