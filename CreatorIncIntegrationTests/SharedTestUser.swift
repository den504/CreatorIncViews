//
//  SharedTestUser.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 30/08/2026.
//
import Foundation
@testable import CreatorInc

@MainActor
enum SharedTestUser {
    static let email = "tester@gmail.com"
    static let password = "Password123!"

    static func signIn() async throws {
        let auth = SupabaseAuthService(config: IntegrationTestConfig.supabase)
        do{
            _ = try await auth.login(email: email, password: password)
        }catch{
            try await auth.createAccount(email:email, password: password, role: .creator)
            _ = try await auth.login(email: email, password: password)
        }
        let profiles = SupabaseProfileService(config: IntegrationTestConfig.supabase)
        
        _ = try await profiles.saveCreatorProfile(displayName: "Test Creator", niche: nil, profilePhotoURL: nil, bio: nil)
        _ = try await profiles.saveBrandProfile(
            companyName: "CreatorInc Test Brand",
            brandIntro: nil, industries: nil,
            website: nil, location: nil, targetCreatorNiches: nil
        )
    }
}
