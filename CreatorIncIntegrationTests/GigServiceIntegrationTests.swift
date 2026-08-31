import Testing
import Foundation
@testable import CreatorInc

@MainActor
struct GigServiceIntegrationTests {
    @Test("Creating a gig")
    func createAndFetchGig() async throws {
        try await SharedTestUser.signIn()
        let service = SupabaseGigService(config: IntegrationTestConfig.supabase)
        let title = "Test Gig \(UUID().uuidString.prefix(8))"
        let created = try await service.createGig(
            title: title, budget: 250.50, brief: "Integration test",
            closesAt: Date().addingTimeInterval(86_400),
            requirements: ["Post weekly"], deliverables: ["One Video"], tags:["Travel"]
        )
        let gigs = try await service.fetchGigs()
        #expect(created.status == .open)
        #expect(gigs.map(\.id).contains(created.id))
    }
}