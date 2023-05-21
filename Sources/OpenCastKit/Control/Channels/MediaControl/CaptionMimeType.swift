//
//  CaptionMimeType.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

enum CaptionMimeType: String, Codable {
    case CEA608 = "CEA608"
    case TTML = "TTML"
    case VTT = "VTT"
    case TTML_MP4 = "TTML_MP4"
}
