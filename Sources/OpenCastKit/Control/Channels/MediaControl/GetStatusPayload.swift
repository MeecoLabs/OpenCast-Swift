//
//  GetStatusPayload.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public struct GetStatusPayload: CastJSONPayload {
    var requestId: Int?
    let type = "GET_STATUS"
    let sessionId: String
}
