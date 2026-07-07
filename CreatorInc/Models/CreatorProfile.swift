//
//  CreatorProfile.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 07/07/2026.
//

import Foundation

struct CreatorProfile: Decodable {
    let id: UUID
    let userId: UUID
    let displayName: String
    let niche: String?
    let profilePhotoURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case displayName = "display_name"
        case niche
        case profilePhotoURL = "profile_photo_url"
    }
}
