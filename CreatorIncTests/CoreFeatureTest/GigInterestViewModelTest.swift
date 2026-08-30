import Foundation
import Testing
@testable import CreatorInc

@MainActor
struct GigInterestViewModelTest {
    @Test("submits interest once")
    func submitInterestOnce() async {
        let service = GigInterestServiceSpy()
        let viewModel = GigInterestViewModel(service: service)
        let gigID = UUID()

        await viewModel.indicateInterest(gigID: gigID)
        await viewModel.indicateInterest(gigID: gigID)

        #expect(service.indicatedGigIDs == [gigID])
        #expect(viewModel.hasIndicatedInterest)

    }


}

final class GigInterestServiceSpy: GigInterestServicing {
    private(set) var indicatedGigIDs: [UUID] = []

    func fetchInterest(gigID: UUID) async throws -> GigInterest? { nil }
    func indicateInterest(gigID: UUID) async throws -> GigInterest {
        indicatedGigIDs.append(gigID)
        let interests = GigInterest(id:UUID(), gigId: gigID, creatorUserId: UUID(),createdAt: Date(timeIntervalSince1970:0))
        return interests
    }
    func fetchInterestCount(gigID: UUID) async throws -> Int { 0 }
    func fetchInterestedCreators(gigID: UUID) async throws -> [CreatorProfile]{ [] }
    func fetchInterestedGigs() async throws -> [Gig]{ [] }
}