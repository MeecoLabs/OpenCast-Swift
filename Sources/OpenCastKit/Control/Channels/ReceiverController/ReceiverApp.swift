//
//  ReceiverApp.swift
//  
//
//  Created by Dustin Steiner on 22.05.23.
//

import Foundation

public struct ReceiverApp: Codable, Equatable {
    public let appId: String
    public let appType: String
    public let displayName: String
    public let iconUrl: String
    public let isIdleScreen: Bool
    public let launchedFromCloud: Bool
    public let namespaces: [ReceiverAppNamespace]
    public let sessionId: String
    public let statusText: String
    public let transportId: String
    public let universalAppId: String
}

extension ReceiverApp {
    init(json: NSDictionary) {
        self.appId = json["appId"] as! String
        self.appType = json["appType"] as! String
        self.displayName = json["displayName"] as! String
        self.iconUrl = json["iconUrl"] as! String
        self.isIdleScreen = json["isIdleScreen"] as! Bool
        self.launchedFromCloud = json["launchedFromCloud"] as! Bool
        let namespaces = json["namespaces"] as! [NSDictionary]
        self.namespaces = namespaces.map({ ReceiverAppNamespace(json: $0) })
        self.sessionId = json["sessionId"] as! String
        self.statusText = json["statusText"] as! String
        self.transportId = json["transportId"] as! String
        self.universalAppId = json["universalAppId"] as! String
    }
}
