//
//  CastJSONPayload.swift
//  Caster
//
//  Created by Dustin Steiner on 17/02/2023.
//

import Foundation

protocol CastJSONPayload: Encodable {
    var type: String { get }
    var requestId: Int? { get set }
}
