//
//  Track.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

struct Track: Codable {
    let isInband: Bool?
    let language: String?
    let name: String?
    let roles: [String]?
    let subtype: String?
    let trackContentId: String?
    let trackContentType: String? // or CaptionMimeType
    let trackId: Int
    let type: TrackType?
}
