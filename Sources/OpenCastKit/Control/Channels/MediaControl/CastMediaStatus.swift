//
//  CastMediaStatus.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public struct CastMediaStatus: Codable, Equatable {
    public let mediaSessionId: Int
    // TODO
}

extension CastMediaStatus {
    init(json: NSDictionary) {
        print("json = \(json)")
        mediaSessionId = json["mediaSessionId"] as? Int ?? 0
    }
}
