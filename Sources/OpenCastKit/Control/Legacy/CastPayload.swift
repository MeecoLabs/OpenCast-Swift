//
//  CastPayload.swift
//  Caster
//
//  Created by Dustin Steiner on 17/02/2023.
//

import Foundation

enum CastPayload {
    case json(Encodable)
    case data(Data)
  
    init(_ json: Encodable) {
        self = .json(json)
    }
  
    init(_ data: Data) {
        self = .data(data)
    }
}
