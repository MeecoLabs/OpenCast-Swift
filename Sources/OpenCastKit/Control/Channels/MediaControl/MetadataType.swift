//
//  MetadataType.swift
//  OpenCastKit
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public enum MetadataType: String, Codable {
    case generic = "GENERIC"
    case movie = "MOVIE"
    case tvShow = "TV_SHOW"
    case musicTrack = "MUSIC_TRACK"
    case photo = "PHOTO"
    case audiobookChapter = "AUDIOBOOK_CHAPTER"
}
