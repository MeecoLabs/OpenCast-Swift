//
//  RequestDispatchable.swift
//  
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

extension RequestDispatchable {
    func request(withNamespace namespace: String, destinationId: String, payload: CastJSONPayload) -> CastRequest {
        var payload = payload
        let requestId = nextRequestId()
        payload.requestId = requestId
        return CastRequest(id: requestId, namespace: namespace, destinationId: destinationId, payload: payload)
    }
    
    func request(withNamespace namespace: String, destinationId: String, payload: Data) -> CastRequest {
        let requestId = nextRequestId()
        return CastRequest(id: requestId, namespace: namespace, destinationId: destinationId, payload: payload)
    }
}
