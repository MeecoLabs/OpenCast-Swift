//
//  QueueItem.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public struct QueueItem: Codable {
    let activeTrackIds: [Int]?
    let autoplay: Bool?
    let itemId: Int?
    let media: MediaInformation?
    let orderId: Int?
    let preloadTime: Int?
    let startTime: Int?
}
