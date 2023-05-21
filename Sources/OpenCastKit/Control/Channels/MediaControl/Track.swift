//
//  Track.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public struct Track: Codable {
    public init(isInband: Bool? = nil, language: String? = nil, name: String? = nil, roles: [String]? = nil, subtype: TextTrackType? = nil, trackContentId: String? = nil, trackContentType: String? = nil, trackId: Int, type: TrackType? = nil) {
        self.isInband = isInband
        self.language = language
        self.name = name
        self.roles = roles
        self.subtype = subtype
        self.trackContentId = trackContentId
        self.trackContentType = trackContentType
        self.trackId = trackId
        self.type = type
    }
    
    let isInband: Bool?
    let language: String?
    let name: String?
    let roles: [String]?
    let subtype: TextTrackType?
    let trackContentId: String?
    let trackContentType: String? // or CaptionMimeType
    let trackId: Int
    let type: TrackType?
}
