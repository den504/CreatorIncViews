//
//  BrandProfile.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 11/07/2026.
//

import Foundation

struct BrandProfile: Decodable {
    let id : UUID
    let userId: UUID
    let companyName: String
    let brandIntro: String?
    let industries: [String]?
    let website: String?
    let location: String?
    let targetCreatorNiches: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case companyName = "company_name"
        case brandIntro = "brand_intro"
        case industries
        case website
        case location
        case targetCreatorNiches = "target_creator_niches"
    }
}
