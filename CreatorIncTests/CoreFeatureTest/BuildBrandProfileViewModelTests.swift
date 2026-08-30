import Foundation
import Testing
@testable import CreatorInc

@MainActor
struct BuildBrandProfileViewModelTests {
    @Test("Saves a valid Brand Profile")
    func savesValidBrandProfile() async throws {
        let service = ProfileServiceSpy()
        let expectedProfile = BrandProfile(id:UUID(), userId: UUID(), companyName: "Creator Inc", 
        brandIntro: "Creative campaigns", industries: ["Tech"], website: "creator.inc", location: "London",
        targetCreatorNiches:["Travel"])
        service.brandProfileToReturn = expectedProfile
        let viewModel = BuildBrandProfileViewModel(profileService: service)
        viewModel.companyName = " Creator Inc "
        viewModel.brandIntro = "Creative campaigns"
        viewModel.selectedIndustries = ["Tech"]
        viewModel.website = " creator.inc "
        viewModel.location = " London "
        viewModel.targetCreatorNiches = ["Travel"]
        let result = await viewModel.save()

        let call = try #require(service.brandReceived)
        let savedProfile = try #require(result)
        #expect(savedProfile.id == expectedProfile.id)
        #expect(call.companyName == "Creator Inc")
        #expect(call.brandIntro == "Creative campaigns")
        #expect(call.industries == ["Tech"])
        #expect(call.website == "creator.inc")
        #expect(call.location == "London")
        #expect(call.targetCreatorNiches == ["Travel"])

    }
}