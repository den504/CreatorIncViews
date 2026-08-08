//
//  GigInterestService.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 07/08/2026.
//

import Foundation
import Supabase


protocol GigInterestServicing {
    func fetchInterest(gigID: UUID) async throws -> GigInterest?
    func indicateInterest(gigID: UUID) async throws -> GigInterest
    func fetchInterestCount(gigID: UUID) async throws -> Int

}


struct SupabaseGigInterestService: GigInterestServicing {
    private let client: SupabaseClient
    init(config: SupabaseConfig) {
        client = SupabaseClient(supabaseURL: config.projectURL, supabaseKey: config.anonKey) }
    

    private func currentUserID() async throws -> UUID {
        let session = try await client.auth.session
        return session.user.id
    }
    
    func fetchInterest(gigID: UUID) async throws -> GigInterest? {
        let userID = try await currentUserID()
        let interests: [GigInterest] = try await client.database.from("gig_interests").select().eq("gig_id", value: gigID).eq("creator_user_id", value: userID).limit(1).execute().value
        return interests.first
    }
    
    func indicateInterest(gigID: UUID) async throws -> GigInterest {
        let userID = try await currentUserID()
        let data = GigInterestInsertData(gigId: gigID, creatorUserId: userID)
        return try await client.database.from("gig_interests").insert(data).select().single().execute().value
    }
    
    func fetchInterestCount(gigID: UUID) async throws -> Int {
        let response = try await client.database.from("gig_interests").select("id", head: true, count: .exact).eq("gig_id", value: gigID).execute()
        return response.count ?? 0
    }
}


struct UnavailableGigInterestService: GigInterestServicing {
    func fetchInterest(gigID: UUID) async throws -> GigInterest? { throw AuthValidationError.missingSupabaseConfig }
    func indicateInterest(gigID: UUID) async throws -> GigInterest { throw AuthValidationError.missingSupabaseConfig }
    func fetchInterestCount(gigID: UUID) async throws -> Int { throw AuthValidationError.missingSupabaseConfig}
}
