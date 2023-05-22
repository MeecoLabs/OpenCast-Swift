//
//  ReceiverStatusPayload.swift
//  
//
//  Created by Dustin Steiner on 22.05.23.
//

import Foundation

struct ReceiverStatusPayload: CastJSONPayload {
    var requestId: Int?
    let type = "RECEIVER_STATUS"
    let status: ReceiverStatus
}

extension ReceiverStatusPayload {
    init(json: NSDictionary) {
        let status = json["status"] as! NSDictionary
        self.status = ReceiverStatus(json: status)
    }
}
