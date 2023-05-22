//
//  SetVolume.swift
//  
//
//  Created by Dustin Steiner on 22.05.23.
//

import Foundation

struct SetVolume: Codable {
    public init(level: Float? = nil, muted: Bool? = nil) {
        self.level = level
        self.muted = muted
    }
    
    let level: Float?
    let muted: Bool?
}
