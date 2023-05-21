//
//  EditTracksInfoRequest.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

struct EditTracksInfoRequest: CastJSONPayload {
    var requestId: Int?
    let type = "EDIT_TRACKS_INFO"
    let mediaSessionId: Int
    let activeTrackIds: [Int]?
    let textTrackStyle: TextTrackStyle?
}
