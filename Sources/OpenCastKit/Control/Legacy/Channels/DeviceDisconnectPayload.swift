//
//  DeviceDisconnectPayload.swift
//  Caster
//
//  Created by Dustin Steiner on 22/02/2023.
//

import Foundation

struct DeviceDisconnectPayload: CastJSONPayload {
    var requestId: Int?
    let type = "CLOSE"
}
