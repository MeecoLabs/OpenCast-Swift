//
//  CastRequest.swift
//  Caster
//
//  Created by Dustin Steiner on 17/02/2023.
//

import Foundation

struct CastRequest {
    let id: Int
    let namespace: String
    let destinationId: String
    let payload: CastPayload
    
    init(id: Int, namespace: String, destinationId: String, payload: Encodable) {
        self.id = id
        self.namespace = namespace
        self.destinationId = destinationId
        self.payload = CastPayload(payload)
    }
      
    init(id: Int, namespace: String, destinationId: String, payload: Data) {
        self.id = id
        self.namespace = namespace
        self.destinationId = destinationId
        self.payload = CastPayload(payload)
    }
}
