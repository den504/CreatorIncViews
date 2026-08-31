import Testing
import Foundation
@testable import CreatorInc

@MainActor
struct ProfileServiceIntegrationTests {
    @Test("Saving and reading a creator profile")
    func savesAndReadsCreatorProfile() async throws {
        try await SharedTestUser.signIn()
        let service = SupabaseProfileService(config: IntegrationTestConfig.supabase)
        let name  = "Test Creator \(UUID().uuidString.prefix(8))"
        let saved = try await service.saveCreatorProfile(
            displayName: name, niche: "Travel", profilePhotoURL: nil, bio: "Integration test"
        )
        let fetched = try #require(try await service.fetchCreatorProfile())

        #expect(saved.displayName == name)
        #expect(fetched.displayName == name)
        #expect(fetched.niche == "Travel")
        #expect(fetched.userId == saved.userId)
    }
}
