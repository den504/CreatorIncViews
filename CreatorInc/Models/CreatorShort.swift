//
//  CreatorShort.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 01/08/2026.
//

import Foundation

nonisolated struct CreatorShort: Decodable, Sendable, Identifiable {
    let id: UUID
    let userId: UUID
    let videoURL: String
    let thumbnailURL: String
    let createdAt: Date
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case videoURL = "video_url"
        case thumbnailURL = "thumbnail_url"
        case description
        case createdAt = "created_at"
    }
}

nonisolated struct CreatorShortInsertData: Encodable, Sendable {
    let userId: UUID
    let videoURL: String
    let thumbnailURL: String
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case videoURL = "video_url"
        case thumbnailURL = "thumbnail_url"
        case description
    }

}

