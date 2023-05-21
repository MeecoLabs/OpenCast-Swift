//
//  PlayPayload.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

struct PlayPayload: CastJSONPayload {
    var requestId: Int?
    let type = "PLAY"
    let mediaSessionId: Int
}
