//
//  VolumeRequest.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

struct VolumeRequest: CastJSONPayload {
    var requestId: Int?
    let type = "SET_VOLUME"
    let volume: Volume?
}
