//
//  CastChannel.swift
//  
//
//  Created by Dustin Steiner on 17/02/2023.
//

import Foundation

open class CastChannel {
    let namespace: String
    weak var requestDispatcher: RequestDispatchable!
    
    init(namespace: String) {
        self.namespace = namespace
    }
    
    func send(_ request: CastRequest, response: CastResponseHandler? = nil) {
        requestDispatcher.send(request, response: response)
    }
    
    open func handleResponse(_ json: NSDictionary, sourceId: String) {
        print("\n--JSON response--\n")
        print(json)
    }
      
    open func handleResponse(_ data: Data, sourceId: String) {
        print("\n--Binary response--\n")
    }
}
