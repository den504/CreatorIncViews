//
//  AuthService.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 27/06/2026.
//

import Foundation
import Supabase
import _Helpers

protocol AuthServicing {
    func createAccount(email: String, password: String, role: AccountRole) async throws
    func login(email: String, password: String) async throws -> LoginResult
}

struct SupabaseAuthService: AuthServicing {
    private let client: SupabaseClient
    
    init(config: SupabaseConfig) {
        self.client = SupabaseClient(supabaseURL: config.projectURL, supabaseKey: config.anonKey)
    }
    
    func createAccount(email: String, password: String, role: AccountRole) async throws {
        // [SoC -> Supabase Auth -> role metadata for database trigger]
        try await client.auth.signUp(
            email: email,
            password: password,
            data: ["role": .string(role.rawValue)]
        )
    }
    
    func login(email: String, password: String) async throws -> LoginResult {
        let response = try await client.auth.signIn(email: email, password: password)
        let profile: AccountProfile = try await client.database.from("profiles").select().eq("id", value: response.user.id).single().execute().value //user details is read with role
        return LoginResult(role: profile.role)
        
    }
}

struct UnavailableAuthService: AuthServicing {
    func createAccount(email: String, password: String, role: AccountRole) async throws {
        throw AuthValidationError.missingSupabaseConfig
    }
    func login(email: String, password: String) async throws -> LoginResult {
        throw AuthValidationError.missingSupabaseConfig
    }
}
