//
//  AccountProfile.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 06/07/2026.
//

import Foundation

nonisolated struct AccountProfile: Decodable, Sendable {
    let id: UUID
    let role: AccountRole
    let email: String?
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, role, email
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
}

//non-isolated essentially execution safety of the data passed
nonisolated struct AccountProfileInsert: Encodable, Sendable {
    let id: UUID
    let role: AccountRole
    let email: String?
}
