//
//  CastMediaLoadOptions.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public struct LoadOptions: Codable {
    public init(contentFilteringMode: ContentFilteringMode? = nil) {
        self.contentFilteringMode = contentFilteringMode
    }
    
    let contentFilteringMode: ContentFilteringMode?
}
