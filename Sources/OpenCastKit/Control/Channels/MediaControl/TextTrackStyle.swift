//
//  TextTrackStyle.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public struct TextTrackStyle: Codable {
    let backgroundColor: String?
    let edgeColor: String?
    let edgeType: TextTrackEdgeType?
    let fontFamily: String?
    let fontGenericFamily: TextTrackFontGenericFamily?
    let fontScale: Float?
    let fontStyle: TextTrackFontStyle?
    let foregroundColor: String?
    let windowColor: String?
    let windowRoundedCornerRadius: Int?
    let windowType: TextTrackWindowType?
}
