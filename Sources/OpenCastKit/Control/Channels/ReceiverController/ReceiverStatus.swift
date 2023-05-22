//
//  ReceiverStatus.swift
//  
//
//  Created by Dustin Steiner on 22.05.23.
//

import Foundation

public struct ReceiverStatus: Codable, Equatable {
    public let applications: [ReceiverApp]?
    public let isActiveInput: Bool
    public let isStandBy: Bool
    // let userEq: AnyObject
    public let volume: Volume
}

extension ReceiverStatus {
    init(json: NSDictionary) {
        if let applications = json["applications"] as? [NSDictionary] {
            self.applications = applications.compactMap { ReceiverApp(json: $0) }
        } else {
            self.applications = nil
        }
        
        self.isActiveInput = json["isActiveInput"] as! Bool
        
        self.isStandBy = json["isStandBy"] as! Bool
        
        let volume = json["volume"] as! NSDictionary
        self.volume = Volume(json: volume)
    }
}
