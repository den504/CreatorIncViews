//
//  GigInterest.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 07/08/2026.
//

import Foundation

nonisolated struct GigInterest: Decodable, Sendable, Identifiable {
    let id: UUID
    let gigId: UUID
    let creatorUserId: UUID
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case gigId = "gig_id"
        case creatorUserId = "creator_user_id"
        case createdAt = "created_at"
    }
}


nonisolated struct GigInterestInsertData: Encodable, Sendable {
    let gigId: UUID
    let creatorUserId: UUID
    enum CodingKeys: String, CodingKey {
        case gigId = "gig_id"
        case creatorUserId = "creator_user_id"
    }
}
