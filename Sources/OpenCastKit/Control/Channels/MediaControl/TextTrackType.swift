//
//  TextTrackType.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public enum TextTrackType: String, Codable {
    case subtitles = "SUBTITLES"
    case captions = "CAPTIONS"
    case descriptions = "DESCRIPTIONS"
    case chapters = "CHAPTERS"
    case metadata = "METADATA"
}
