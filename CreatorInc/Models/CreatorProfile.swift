//
//  CreatorProfile.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 07/07/2026.
//

import Foundation

//reads saved data returned by superbase
nonisolated struct CreatorProfile: Decodable, Sendable {
    let id: UUID
    let userId: UUID
    let displayName: String
    let niche: String?
    let bio: String?
    let profilePhotoURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case bio
        case userId = "user_id"
        case displayName = "display_name"
        case niche
        case profilePhotoURL = "profile_photo_url"
    }
}

//sends new data to Supabase
nonisolated struct CreatorProfileSaveData: Encodable, Sendable {
    let userId: UUID
    let displayName: String
    let niche: String?
    let profilePhotoURL: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id", displayName = "display_name", niche
        case profilePhotoURL = "profile_photo_url"
        case bio
    }
}

