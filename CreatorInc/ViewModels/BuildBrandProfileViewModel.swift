//
//  BuildBrandProfileViewModel.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 11/07/2026.
//

import Foundation
import Combine

@MainActor
class BuildBrandProfileViewModel: ObservableObject {
    @Published var companyName: String = ""
    @Published var brandIntro: String = ""
    @Published var selectedIndustries: [String] = []
    @Published var website: String = ""
    @Published var location: String = ""
    @Published var message: String?
    @Published var targetCreatorNiches: [String] = []
    
    @Published private(set) var isLoading = false
    
    private let profileService: ProfileServicing
    private let validator = ProfileValidator()
    

    
    let industries = ["Skincare", "Wellness", "Fashion", "Tech", "Food", "Travel"]
    let niches = ["Travel", "LifeStyle", "Fitness", "Beauty"]
    
    init(profileService: ProfileServicing, profile: BrandProfile? = nil) {
        self.profileService = profileService
        companyName = profile?.companyName ?? ""
        brandIntro = profile?.brandIntro ?? ""
        selectedIndustries = profile?.industries ?? []
        website = profile?.website ?? ""
        location = profile?.location ?? ""
        targetCreatorNiches = profile?.targetCreatorNiches ?? []
    }
    
    func save() async -> BrandProfile? { // [
        message = nil
        isLoading = true
        defer { isLoading = false }
        do {
            let name = try validator.validateCompanyName(companyName)
            return try await profileService.saveBrandProfile (
                companyName: name,
                brandIntro: validator.optionalText(brandIntro),
                industries: validator.optionalList(selectedIndustries),
                website: validator.optionalText(website),
                location: validator.optionalText(location),
                targetCreatorNiches: validator.optionalList(targetCreatorNiches)
            )
        }catch {
            message = error.localizedDescription
            return nil
        }
    }

}
