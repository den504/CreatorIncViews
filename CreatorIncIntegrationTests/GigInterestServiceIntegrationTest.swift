import Testing
import Foundation
@testable import CreatorInc

@MainActor
struct GigInterestServiceIntegrationTest {
    @Test("Indicating interest and lists creators")
    func indicatesAndReadsInterest() async throws {
        try await SharedTestUser.signIn()
        let gig = try await SupabaseGigService(config: IntegrationTestConfig.supabase).createGig(
            title:"Interest Gig \(UUID().uuidString.prefix(8))", budget: 100, brief: "Integration test",
            closesAt: Date().addingTimeInterval(86_400),
            requirements: [], deliverables: [], tags:[]
        )
        let service = SupabaseGigInterestService(config: IntegrationTestConfig.supabase)
        let interest = try await service.indicateInterest(gigID: gig.id)
        let creators = try await service.fetchInterestedCreators(gigID: gig.id)
        let count = try await service.fetchInterestCount(gigID: gig.id)
        #expect(count == 1)
        #expect(creators.map(\.userId).contains(interest.creatorUserId))
    }
}