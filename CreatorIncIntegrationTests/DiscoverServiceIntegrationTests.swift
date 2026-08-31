import Testing
import Foundation
@testable import CreatorInc

@MainActor
struct DiscoverServiceIntegrationTests {
    @Test("Validate Open gigs")
    func fetchesOpenGigs() async throws {
        try await SharedTestUser.signIn()
        let gigs = SupabaseGigService(config: IntegrationTestConfig.supabase)
        let gig = try await gigs.createGig(
            title:"Interest Gig \(UUID().uuidString.prefix(8))", budget: 100, brief: "Integration test",
            closesAt: Date().addingTimeInterval(86_400),
            requirements: [], deliverables: [], tags:[]
        )
        let service = SupabaseDiscoverService(config: IntegrationTestConfig.supabase)
        let openGigs = try await service.fetchOpenGigs()
        let foundGigs = try #require(openGigs.first(where: { $0.id == gig.id }))
        #expect(foundGigs.status == .open)
        #expect(foundGigs.companyName == "CreatorInc Test Brand")
    }
}