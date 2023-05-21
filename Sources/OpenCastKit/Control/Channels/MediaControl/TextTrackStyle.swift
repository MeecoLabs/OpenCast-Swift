//
//  TextTrackStyle.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public struct TextTrackStyle: Codable {
    public init(backgroundColor: String? = nil, edgeColor: String? = nil, edgeType: TextTrackEdgeType? = nil, fontFamily: String? = nil, fontGenericFamily: TextTrackFontGenericFamily? = nil, fontScale: Float? = nil, fontStyle: TextTrackFontStyle? = nil, foregroundColor: String? = nil, windowColor: String? = nil, windowRoundedCornerRadius: Int? = nil, windowType: TextTrackWindowType? = nil) {
        self.backgroundColor = backgroundColor
        self.edgeColor = edgeColor
        self.edgeType = edgeType
        self.fontFamily = fontFamily
        self.fontGenericFamily = fontGenericFamily
        self.fontScale = fontScale
        self.fontStyle = fontStyle
        self.foregroundColor = foregroundColor
        self.windowColor = windowColor
        self.windowRoundedCornerRadius = windowRoundedCornerRadius
        self.windowType = windowType
    }
    
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
