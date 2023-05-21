//
//  QueueData.swift
//
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

struct QueueData: Codable {
    let description: String?
    let entity: String?
    let id: String?
    let items: [QueueItem]?
    let name: String?
    let queueType: QueueType?
    let repeatMode: RepeatMode?
    let shuffle: Bool?
    let startIndex: Int?
    let startTime: Int?
}
