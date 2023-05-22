//
//  GetReceiverStatusPayload.swift
//  
//
//  Created by Dustin Steiner on 22.05.23.
//

import Foundation

struct GetReceiverStatusPayload: CastJSONPayload {
    var requestId: Int?
    let type = "GET_STATUS"
}
