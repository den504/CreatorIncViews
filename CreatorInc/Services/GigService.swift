//
//  GigServicing.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 25/07/2026.
//

import Foundation
import Supabase

protocol GigServicing {
    func createGig(title: String, budget: Decimal, brief: String, closesAt: Date, requirements: [String], deliverables: [String], tags: [String]) async throws -> Gig
    func fetchGigs() async throws -> [Gig]
}

struct SupabaseGigService: GigServicing {
    private let client: SupabaseClient
    
    init(config: SupabaseConfig) {
        client = SupabaseClient(supabaseURL: config.projectURL, supabaseKey: config.anonKey)
    }
    
    private func CurrentUserID() async throws -> UUID {
        let session = try await client.auth.session
        return session.user.id
    }
    
    func createGig(title: String, budget: Decimal, brief: String, closesAt: Date, requirements: [String], deliverables: [String], tags: [String]) async throws -> Gig {
        let userID = try await CurrentUserID()
        let data = GigInsertData(brandId: userID,title: title, budget: budget,brief: brief, closesAt: closesAt,requirements: requirements, deliverables: deliverables, tags: tags )
        return try await client.database.from("gigs").insert(data).select().single().execute().value
    }
    
    func fetchGigs() async throws -> [Gig] {
        let userID = try await CurrentUserID()//user id passed to brand id below
        return try await client.database.from("gigs").select().eq("brand_id", value: userID).order("created_at", ascending: false).execute().value
    }
}

struct UnavailableGigService: GigServicing {
    func createGig(title: String, budget: Decimal, brief: String, closesAt: Date, requirements: [String], deliverables: [String], tags: [String]) async throws -> Gig {
        throw AuthValidationError.missingSupabaseConfig
    }
    func fetchGigs() async throws -> [Gig] { throw AuthValidationError.missingSupabaseConfig }
}

