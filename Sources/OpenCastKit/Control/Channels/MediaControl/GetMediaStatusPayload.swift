//
//  GetMediaStatusPayload.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

struct GetMediaStatusPayload: CastJSONPayload {
    var requestId: Int?
    let type = "GET_STATUS"
    let sessionId: String
}