//
//  VolumeControlType.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public enum VolumeControlType: String, Codable {
    case attenuation = "ATTENUATION"
    case fixed = "FIXED"
    case master = "MASTER"
}
