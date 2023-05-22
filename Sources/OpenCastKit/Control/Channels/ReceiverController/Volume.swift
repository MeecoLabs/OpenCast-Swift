//
//  File.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public struct Volume: Codable, Equatable {
    public let controlType: VolumeControlType
    public let level: Float
    public let muted: Bool
    public let stepInterval: Float
}


extension Volume {
    init(json: NSDictionary) {
        let controlType = json["controlType"] as! String
        self.controlType = VolumeControlType(rawValue: controlType)!
        self.level = (json["level"] as! NSNumber).floatValue
        self.muted = json["muted"] as! Bool
        self.stepInterval = (json["stepInterval"] as! NSNumber).floatValue
    }
}
