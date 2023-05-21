//
//  StreamType.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public enum StreamType: String, Codable {
    case buffered = "BUFFERED"
    case live = "LIVE"
    case `none` = "NONE"
}
