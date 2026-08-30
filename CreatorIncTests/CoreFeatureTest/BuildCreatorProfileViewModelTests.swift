import Foundation
import Testing
@testable import CreatorInc

@MainActor
struct BuildCreatorProfileViewModelTests {
    @Test("Saves a valid Creator Profile")
    func savesValidCreatorProfile() async throws {
        let service = ProfileServiceSpy()
        let expectedProfile = CreatorProfile(id:UUID(), userId: UUID(), displayName: "Dave Chapel", 
        niche: "Travel", bio: "Travel creator", profilePhotoURL: nil)
        service.profileToReturn = expectedProfile
        let viewModel = BuildCreatorProfileViewModel(profileService: service)
        viewModel.fullName = " Dave Chapel "
        viewModel.selectedCategory = "Travel"
        viewModel.bio = " Travel creator "
        let result = await viewModel.save()

        let call = try #require(service.received)
        let savedProfile = try #require(result)
        #expect(savedProfile.id == expectedProfile.id)
        #expect(call.displayName == "Dave Chapel")
        #expect(call.niche == "Travel")
        #expect(call.bio == "Travel creator")
        #expect(call.profilePhotoURL == nil)

    }
    

}