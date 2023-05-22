//
//  Channelable.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

protocol Channelable: RequestDispatchable {
    var channels: [String: CastChannel] { get set }
    
    func add(channel: CastChannel)
    func remove(channel: CastChannel)
}
