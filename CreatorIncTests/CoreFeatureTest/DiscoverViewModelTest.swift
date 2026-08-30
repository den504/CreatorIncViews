import Foundation
import Testing
@testable import CreatorInc

@MainActor
struct DiscoverViewModelTest {
    @Test("Loads discovery")
    func loadsDiscovery() async {
        let service = DiscoverServiceSpy()
        let creator = CreatorProfile(
            id: UUID(), userId: UUID(), displayName: "Alex",
            niche: nil, bio: nil, profilePhotoURL: nil
        )
        let gig = Gig(id:UUID(), brandId: UUID(), title: "Summer Campaign", status: .open, 
        budget: 250, brief: "Promote our Product", closesAt: Date(timeIntervalSince1970: 1_893_456_000),
        requirements: [], deliverables: [], tags: [], interestedCount: 0, companyName: "Creator Inc"
        )
        service.creatorCount = 1
        service.creators = [creator]
        service.gigs = [gig]

        let viewModel = DiscoverViewModel(service: service)
        await viewModel.load()

        #expect(viewModel.creators.map(\.id) == [creator.id])
        #expect(viewModel.gigs.map(\.id) == [gig.id])
    }

}

@MainActor
final class DiscoverServiceSpy: DiscoverServicing {
    var creatorCount = 0
    var creators: [CreatorProfile] = []
    var gigs: [Gig] = []


    func fetchCreatorCount() async throws -> Int { creatorCount }
    func fetchCreators(offset: Int, limit: Int) async throws -> [CreatorProfile] { creators }
    func fetchOpenGigs () async throws -> [Gig] { gigs}
}