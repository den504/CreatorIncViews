//
//  AuthService.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 27/06/2026.
//

import Foundation
import Supabase

protocol AuthServicing {
    func createAccount(email: String, password: String) async throws
    func login(email: String, password: String) async throws
}

struct SupabaseAuthService: AuthServicing {
    private let client: SupabaseClient
    
    init(config: SupabaseConfig) {
        self.client = SupabaseClient(supabaseURL: config.projectURL, supabaseKey: config.anonKey)
    }
    
    func createAccount(email: String, password: String) async throws {
        try await client.auth.signUp(email: email, password: password)
    }
    
    func login(email: String, password: String) async throws {
        try await client.auth.signIn(email: email, password: password)
    }
}

struct UnavailableAuthService: AuthServicing {
    func createAccount(email: String, password: String) async throws {
        throw AuthValidationError.missingSupabaseConfig
    }
    func login(email: String, password: String) async throws {
        throw AuthValidationError.missingSupabaseConfig
    }
}
