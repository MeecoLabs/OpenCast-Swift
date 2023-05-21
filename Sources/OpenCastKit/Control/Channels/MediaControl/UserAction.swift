//
//  UserAction.swift
//  
//
//  Created by Dustin Steiner on 21.05.23.
//

import Foundation

enum UserAction: String, Codable {
    case like = "LIKE"
    case dislike = "DISLIKE"
    case follow = "FOLLOW"
    case unfollow = "UNFOLLOW"
    case flag = "FLAG"
    case skipAd = "SKIP_AD"
    case lyrics = "LYRICS"
}
