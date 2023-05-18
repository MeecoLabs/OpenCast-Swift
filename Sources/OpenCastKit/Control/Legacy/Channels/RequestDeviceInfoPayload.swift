//
//  RequestDeviceInfoPayload.swift
//  Caster
//
//  Created by Dustin Steiner on 22/02/2023.
//

import Foundation

struct RequestDeviceInfoPayload: CastJSONPayload {
    var requestId: Int?
    let type = "GET_DEVICE_INFO"
}
