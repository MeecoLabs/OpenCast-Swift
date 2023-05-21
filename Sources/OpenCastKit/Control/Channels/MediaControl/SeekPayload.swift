//
//  SeekPayload.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

struct SeekPayload: CastJSONPayload {
    var requestId: Int?
    let type = "SEEK"
    let sessionId: String
    let currentTime: Float
    let mediaSessionId: Int
}
