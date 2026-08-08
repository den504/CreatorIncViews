//
//  DiscoverService.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 03/08/2026.
//


import Foundation
import Supabase


protocol DiscoverServicing {
    func fetchCreatorCount() async throws -> Int
    func fetchCreators( offset: Int, limit: Int) async throws -> [CreatorProfile]
    func fetchOpenGigs() async throws -> [Gig] 
}


struct SupabaseDiscoverService: DiscoverServicing {
    private let client: SupabaseClient
    
    init(config: SupabaseConfig){
        client = SupabaseClient(supabaseURL: config.projectURL, supabaseKey: config.anonKey)
    }
    
    private func currentUserID() async throws -> UUID {
        let session = try await client.auth.session
        return session.user.id
    }
    func fetchCreatorCount() async throws -> Int {
        let userID = try await currentUserID()
        let response: PostgrestResponse<Void> = try await client.database.from("creator_profiles").select("id", head: true, count: .exact).neq("user_id", value: userID).execute()
        return response.count ?? 0
    }
    
    func fetchCreators( offset: Int, limit: Int) async throws -> [CreatorProfile] {
        let userID = try await currentUserID()
        return try await client.database.from("creator_profiles")
            .select("""
                    id,user_id,display_name,niche,bio,profile_photo_url
                    """)
            .neq("user_id", value: userID)
            .order("id")
            .range(from: offset, to: offset + limit - 1)
            .execute()
            .value
    }
    
    func fetchOpenGigs() async throws -> [Gig] {
        try await client.database.from("gigs").select("*,...brand_profiles!inner(company_name)").eq("status", value: GigStatus.open.rawValue).order("created_at", ascending: false).execute().value
    }
    
}

struct UnavailableDiscoverService: DiscoverServicing {
    func fetchCreatorCount() async throws -> Int {
        throw AuthValidationError.missingSupabaseConfig
    }

    func fetchCreators(offset: Int,limit: Int) async throws -> [CreatorProfile] {
        throw AuthValidationError.missingSupabaseConfig
    }

    func fetchOpenGigs() async throws -> [Gig] {
        throw AuthValidationError.missingSupabaseConfig
    }
}
