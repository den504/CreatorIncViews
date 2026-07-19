//
//  BuildCreatorProfileViewModel.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 11/07/2026.
//

import Foundation
import Combine


@MainActor
class BuildCreatorProfileViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var selectedCategory: String = "Travel"
    @Published var message: String?
    @Published private(set) var isLoading = false
    @Published var selectedPhotoJPEGData: Data?
    @Published var bio: String = ""
    
    let categories = ["Travel", "LifeStyle", "Beauty", "Tech", "Food"]
    private let profileService: ProfileServicing
    private let validator = ProfileValidator()
    
    @Published private(set) var profilePhotoURL: String?
    
    
    init(profileService: ProfileServicing, profile: CreatorProfile? = nil) {
        self.profileService = profileService
        fullName = profile?.displayName ?? ""
        selectedCategory = profile?.niche ?? "Travel"
        profilePhotoURL = profile?.profilePhotoURL
        bio = profile?.bio ?? ""
    }
    
    func save() async -> CreatorProfile? {
        message = nil
        isLoading = true
  
        defer {isLoading = false}
        do {
            let name = try validator.validateCreatorName(fullName)
            let photoURL: String?
            if let photoData = selectedPhotoJPEGData {
                //takes photo and outputs URL
                photoURL = try await profileService.uploadCreatorPhoto(photoData)
            } else {
                photoURL = profilePhotoURL
            }

            let saveProfile = try await profileService.saveCreatorProfile(displayName: name, niche: selectedCategory, profilePhotoURL: photoURL, bio: validator.optionalText(bio))
            return saveProfile
        } catch {
            message = error.localizedDescription
            return nil
        }
    }
    
    
}
