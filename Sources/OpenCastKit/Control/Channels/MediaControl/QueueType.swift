//
//  QueueType.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

enum QueueType: String, Codable {
    case album = "ALBUM"
    case playlist = "PLAYLIST"
    case audiobook = "AUDIOBOOK"
    case radioStation = "RADIO_STATION"
    case podcastSeries = "PODCAST_SERIES"
    case tvSeries = "TV_SERIES"
    case videoPlaylist = "VIDEO_PLAYLIST"
    case liveTv = "LIVE_TV"
    case movie = "MOVIE"
}
