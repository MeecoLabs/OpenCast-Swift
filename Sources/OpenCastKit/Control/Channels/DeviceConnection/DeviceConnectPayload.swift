//
//  DeviceConnectPayload.swift
//  
//
//  Created by Dustin Steiner on 22/02/2023.
//

import Foundation

struct DeviceConnectPayload: CastJSONPayload {
    var requestId: Int?
    let type = "CONNECT"
}