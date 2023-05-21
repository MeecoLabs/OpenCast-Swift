//
//  StopPayload.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

struct StopPayload: CastJSONPayload {
    var requestId: Int?
    let type = "STOP"
    let mediaSessionId: Int
}
