//
//  BrandProfile.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 11/07/2026.
//

import Foundation
//reads saved data returned by superbase
nonisolated struct BrandProfile: Decodable, Sendable {
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

//sends new data to Supabase
nonisolated struct BrandProfileSaveData: Encodable, Sendable {
    let userId: UUID
    let companyName: String
    let brandIntro: String?
    let industries: [String]?
    let website: String?
    let location: String?
    let targetCreatorNiches: [String]?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id", companyName = "company_name"
        case brandIntro = "brand_intro", industries, website, location
        case targetCreatorNiches = "target_creator_niches"
    }
    
}
