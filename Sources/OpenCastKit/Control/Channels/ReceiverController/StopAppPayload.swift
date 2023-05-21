//
//  StopAppPayload.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

struct StopAppPayload: CastJSONPayload {
    var requestId: Int?
    let type = "STOP"
    let sessionId: String
}
