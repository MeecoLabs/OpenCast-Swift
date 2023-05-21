//
//  RepeatMode.swift
//
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public enum RepeatMode: String, Codable {
    case repeatOff = "REPEAT_OFF"
    case repeatAll = "REPEAT_ALL"
    case repeatSingle = "REPEAT_SINGLE"
    case repeatAllAndShuffle = "REPEAT_ALL_AND_SHUFFLE"
}
