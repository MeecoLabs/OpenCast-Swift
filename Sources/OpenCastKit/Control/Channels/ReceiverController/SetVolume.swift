//
//  SetVolume.swift
//  
//
//  Created by Dustin Steiner on 22.05.23.
//

import Foundation

public struct SetVolume: Codable, Equatable {
    public init(level: Float? = nil, muted: Bool? = nil) {
        self.level = level
        self.muted = muted
    }
    
    public let level: Float?
    public let muted: Bool?
}

extension SetVolume {
    init(json: NSDictionary) {
        self.level = json["level"] as? Float
        self.muted = json["muted"] as? Bool
    }
}
