import Testing
import Foundation
@testable import CreatorInc

@MainActor
struct AuthServiceIntegrationTests {
    @Test("Sign up creates a profile with a chosen role")
    func signUpCreatesProfileWithRole() async throws {
        let service = SupabaseAuthService(config: IntegrationTestConfig.supabase)
        let email = "test-\(UUID().uuidString.lowercased())@gmail.com"
        let password = "Password123!"

        try await service.createAccount(email:email, password: password, role: .creator)
        let result = try await service.login(email: email, password: password)

        #expect(result.role == .creator)
        #expect(result.email == email)
        try await service.signOut()
    }
}
