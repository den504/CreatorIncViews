import Foundation
@testable import CreatorInc

@MainActor
final class ProfileServiceSpy: ProfileServicing {
    private(set) var received: (displayName: String, niche: String?, profilePhotoURL: String?, bio: String?)?
    var profileToReturn: CreatorProfile?
    private(set) var brandReceived: (companyName: String, brandIntro: String?, industries:[String]?,
    website: String?, location: String?, 
    targetCreatorNiches: [String]?)?
    var brandProfileToReturn: BrandProfile?

    func saveCreatorProfile(displayName: String, niche: String?, profilePhotoURL: String?, bio: String?) async throws -> CreatorProfile{
        received = (displayName, niche, profilePhotoURL, bio)
        guard let profileToReturn else { throw NSError (domain: "ProfileServiceSpy", code: 1)}
        return profileToReturn
    }
    func fetchCreatorProfile() async throws -> CreatorProfile? {nil}
    func fetchBrandProfile() async throws -> BrandProfile? {nil}
    func saveBrandProfile(companyName: String, brandIntro: String?, industries: [String]?, 
    website: String?, location: String?, 
    targetCreatorNiches:[String]?) async throws -> BrandProfile 
    {
        brandReceived = (companyName, brandIntro, industries, website, location, targetCreatorNiches) 
        guard let brandProfileToReturn else {throw NSError (domain: "ProfileServiceSpy", code: 2)}
        return brandProfileToReturn
    }
    func uploadCreatorPhoto(_ jpegData: Data) async throws -> String { throw NSError (domain: "ProfileServiceSpy", code: 1)}
}