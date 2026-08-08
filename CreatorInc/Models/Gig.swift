//
//  Gig.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 20/07/2026.
//

import Foundation

nonisolated struct Gig: Decodable, Sendable, Identifiable {
    let id: UUID
    let brandId: UUID
    let title: String
    let status: GigStatus
    let budget: Decimal
    let brief: String
    let closesAt: Date
    let requirements: [String]
    let deliverables: [String]
    let tags: [String]
    let interestedCount: Int
    let companyName: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, status, budget, brief, tags
        case brandId = "brand_id"
        case closesAt = "closes_at"
        case requirements
        case deliverables
        case interestedCount = "interested_count"
        case companyName = "company_name"
    }
    
}


nonisolated enum GigStatus: String, CaseIterable,Identifiable, Codable, Sendable {
    case open
    case closed
    
    var id: String { rawValue }

}

nonisolated struct GigInsertData: Encodable, Sendable {
    let brandId: UUID
    let title: String
    let status: GigStatus = .open
    let budget: Decimal
    let brief: String
    let closesAt: Date
    let requirements: [String]
    let deliverables: [String]
    let tags: [String]
    
    enum CodingKeys: String, CodingKey {
        case title, status, budget, brief, tags
        case brandId = "brand_id"
        case closesAt = "closes_at"
        case requirements, deliverables
    }
}
