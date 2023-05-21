//
//  TextTrackEdgeType.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

enum TextTrackEdgeType: String, Codable {
    case `none` = "NONE"
    case outline = "OUTLINE"
    case dropShadow = "DROP_SHADOW"
    case raised = "RAISED"
    case depressed = "DEPRESSED"
}
