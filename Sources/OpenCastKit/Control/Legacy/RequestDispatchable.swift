//
//  RequestDispatchable.swift
//  Caster
//
//  Created by Dustin Steiner on 17/02/2023.
//

import Foundation

protocol RequestDispatchable: AnyObject {
    func nextRequestId() -> Int
    
    func request(withNamespace namespace: String, destinationId: String, payload: CastJSONPayload) -> CastRequest
    func request(withNamespace namespace: String, destinationId: String, payload: Data) -> CastRequest
    
    func send(_ request: CastRequest, response: CastResponseHandler?)
}
