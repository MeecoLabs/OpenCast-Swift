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
        var json = json
        if let statuses = json["status"] as? [NSDictionary],
              let status = statuses.first {
            json = status
        }
        mediaSessionId = json["mediaSessionId"] as? Int ?? 0
    }
}
