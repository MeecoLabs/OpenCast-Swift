//
//  QueueData.swift
//
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public struct QueueData: Codable {
    public init(description: String? = nil, entity: String? = nil, id: String? = nil, items: [QueueItem]? = nil, name: String? = nil, queueType: QueueType? = nil, repeatMode: RepeatMode? = nil, shuffle: Bool? = nil, startIndex: Int? = nil, startTime: Int? = nil) {
        self.description = description
        self.entity = entity
        self.id = id
        self.items = items
        self.name = name
        self.queueType = queueType
        self.repeatMode = repeatMode
        self.shuffle = shuffle
        self.startIndex = startIndex
        self.startTime = startTime
    }
    
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
