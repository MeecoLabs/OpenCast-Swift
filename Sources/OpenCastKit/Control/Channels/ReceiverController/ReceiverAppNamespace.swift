//
//  ReceiverAppNamespace.swift
//  
//
//  Created by Dustin Steiner on 22.05.23.
//

import Foundation

public struct ReceiverAppNamespace: Codable, Equatable {
    public let name: String
}


extension ReceiverAppNamespace {
    init(json: NSDictionary) {
        self.name = json["name"] as! String
    }
}
