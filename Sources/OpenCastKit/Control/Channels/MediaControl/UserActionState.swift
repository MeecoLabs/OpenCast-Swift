//
//  UserActionState.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public struct UserActionState: Codable {
    public init(userAction: UserAction) {
        self.userAction = userAction
    }
    
    let userAction: UserAction
}
