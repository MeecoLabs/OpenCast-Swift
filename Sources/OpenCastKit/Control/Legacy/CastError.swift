//
//  CastError.swift
//  Caster
//
//  Created by Dustin Steiner on 22/02/2023.
//

import Foundation

public enum CastError: Error {
    case request(String)
    case launch(String)
    case load(String)
}
