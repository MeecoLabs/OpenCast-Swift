//
//  Break.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

struct Break: Codable {
    let breakClipIds: [String]?
    let duration: Int?
    let id: String
    let isEmbedded: Bool?
    let isWatched: Bool
    let position: Int
}
