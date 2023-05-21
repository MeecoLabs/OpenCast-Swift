//
//  HlsSegmentFormat.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public enum HlsSegmentFormat: String, Codable {
    case AAC = "AAC"
    case AC3 = "AC3"
    case MP3 = "MP3"
    case TS = "TS"
    case TS_AAC = "TS_AAC"
    case TS_HE_AAC = "TS_HE_AAC"
    case E_AC3 = "E_AC3"
    case FMP4 = "FMP4"
}
