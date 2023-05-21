//
//  VastAdsRequest.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

public struct VastAdsRequest: Codable {
    public init(adsResponse: String? = nil, adTagUrl: String? = nil) {
        self.adsResponse = adsResponse
        self.adTagUrl = adTagUrl
    }
    
    let adsResponse: String?
    let adTagUrl: String?
}
