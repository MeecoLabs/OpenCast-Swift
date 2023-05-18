//
//  HeartbeatPongPayload.swift
//  Caster
//
//  Created by Dustin Steiner on 22/02/2023.
//

import Foundation

struct HeartbeatPongPayload: CastJSONPayload {
    var requestId: Int?
    let type = "PONG"
}
