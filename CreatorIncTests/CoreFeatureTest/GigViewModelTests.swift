import Foundation
import Testing

@testable import CreatorInc

@MainActor
struct GigViewModelTests {
    @Test("Save a valid gig")
    func savesValidGig() async throws {
        let service = GigServiceSpy()
        let closesAt = Date(timeIntervalSince1970: 1_800_000_000)
        let expectedGig = Gig(id: UUID(), brandId: UUID(), title: "Summer Campaign", status: .open, budget: 250.50,brief: "Promote our product", closesAt: closesAt, requirements: ["Post weekly"], deliverables: ["One Video"], tags: ["Travel"], interestedCount: 0, companyName: "CreatorInc")
        service.gigToReturn = expectedGig
        let viewModel = GigViewModel(gigService: service)
        viewModel.title = " Summer Campaign "
        viewModel.budgetText = " 250.50 "
        viewModel.brief = " Promote our product "
        viewModel.closesAt = closesAt
        viewModel.requirementsText = " Post weekly \n\n"
        viewModel.deliverablesText = " One video "
        viewModel.selectedTags = ["Travel"]
        let result = await viewModel.save()
        
        let call = try #require(service.received)
        let savedGig = try #require(result)
        #expect(service.createCallCount == 1)
        #expect(savedGig.id == expectedGig.id)
        #expect (call.title == "Summer Campaign")
        #expect (call.budget == 250.50)
        #expect (call.brief == "Promote our product")
        #expect (call.closesAt == closesAt)
        #expect (call.requirements ==  ["Post weekly"])
        #expect (call.deliverables ==  ["One video"])
        #expect (call.tags == ["Travel"])
    }
    
    @Test("Does not save an Invalid Gig")
    func rejectsInvalidGig() async {
        let service =  GigServiceSpy(), viewModel = GigViewModel(gigService: service)
        _ = await viewModel.save()
        #expect(service.createCallCount == 0)
        
    }

}

@MainActor
private final class GigServiceSpy: GigServicing{
    private(set) var createCallCount = 0
    private(set) var received: (title:String, budget: Decimal, brief: String, closesAt: Date, requirements: [String], deliverables: [String], tags: [String])?
    
    var gigToReturn: Gig?
    
    func createGig(title:String, budget: Decimal, brief: String, closesAt: Date, requirements: [String], deliverables: [String], tags: [String]) async throws -> Gig {
        createCallCount += 1
        received = (title:title, budget: budget, brief: brief, closesAt: closesAt, requirements: requirements, deliverables: deliverables, tags: tags)
        guard let gigToReturn else {throw NSError (domain: "GigServiceSpy", code: 1)}
        return gigToReturn
    }
    
    func fetchGigs() async throws -> [Gig] {[]}
}


