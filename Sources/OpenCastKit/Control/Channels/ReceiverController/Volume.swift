//
//  File.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public struct Volume: Codable {
    public init(controlType: VolumeControlType?, level: Float? = nil, muted: Bool? = nil, stepInterval: Double?) {
        self.controlType = controlType
        self.level = level
        self.muted = muted
        self.stepInterval = stepInterval
    }
    
    let controlType: VolumeControlType?
    let level: Float?
    let muted: Bool?
    let stepInterval: Double?
}
