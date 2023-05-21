//
//  QueueItem.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public struct QueueItem: Codable {
    public init(activeTrackIds: [Int]? = nil, autoplay: Bool? = nil, itemId: Int? = nil, media: MediaInformation? = nil, orderId: Int? = nil, preloadTime: Int? = nil, startTime: Int? = nil) {
        self.activeTrackIds = activeTrackIds
        self.autoplay = autoplay
        self.itemId = itemId
        self.media = media
        self.orderId = orderId
        self.preloadTime = preloadTime
        self.startTime = startTime
    }
    
    let activeTrackIds: [Int]?
    let autoplay: Bool?
    let itemId: Int?
    let media: MediaInformation?
    let orderId: Int?
    let preloadTime: Int?
    let startTime: Int?
}
