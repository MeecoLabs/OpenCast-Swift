//
//  CastResponseHandler.swift
//  Caster
//
//  Created by Dustin Steiner on 22/02/2023.
//

import Foundation

typealias CastResponseHandler = (Result<NSDictionary, CastError>) -> Void
