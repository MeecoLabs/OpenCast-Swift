//
//  PausePayload.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

struct PausePayload: CastJSONPayload {
    var requestId: Int?
    let type = "PAUSE"
    let mediaSessionId: Int
}
