//
//  MediaStatusPayload.swift
//  
//
//  Created by Dustin Steiner on 22.05.23.
//

import Foundation

struct MediaStatusPayload: CastJSONPayload {
    var requestId: Int?
    let type = "MEDIA_STATUS"
    let status: [CastMediaStatus]
}

extension MediaStatusPayload {
    init(json: NSDictionary) {
        let statuses = json["status"] as! [NSDictionary]
        self.status = statuses.map({ CastMediaStatus(json: $0) })
    }
}
