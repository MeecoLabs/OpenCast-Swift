//
//  Break.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public struct Break: Codable {
    public init(breakClipIds: [String]? = nil, duration: Int? = nil, id: String, isEmbedded: Bool? = nil, isWatched: Bool, position: Int) {
        self.breakClipIds = breakClipIds
        self.duration = duration
        self.id = id
        self.isEmbedded = isEmbedded
        self.isWatched = isWatched
        self.position = position
    }
    
    let breakClipIds: [String]?
    let duration: Int?
    let id: String
    let isEmbedded: Bool?
    let isWatched: Bool
    let position: Int
}
