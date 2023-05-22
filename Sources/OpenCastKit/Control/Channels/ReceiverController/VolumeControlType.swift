//
//  VolumeControlType.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public enum VolumeControlType: String, Codable, Equatable {
    case attenuation = "attenuation"
    case fixed = "fixed"
    case master = "master"
}
