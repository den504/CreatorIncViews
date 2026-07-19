//
//  ProfileService.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 14/07/2026.
//

import Foundation
import Supabase

protocol ProfileServicing {
    func fetchCreatorProfile() async throws -> CreatorProfile?
    func saveCreatorProfile(displayName: String, niche: String?, profilePhotoURL: String?, bio: String?) async throws -> CreatorProfile
    func fetchBrandProfile() async throws -> BrandProfile?
    func saveBrandProfile(
        companyName: String, brandIntro: String?,
        industries: [String]?, website: String?,
        location: String?, targetCreatorNiches: [String]?
    ) async throws -> BrandProfile
    func uploadCreatorPhoto(_ jpegData: Data) async throws -> String
}

struct SupabaseProfileService: ProfileServicing {
    private let client: SupabaseClient
    
    init(config: SupabaseConfig){
        client = SupabaseClient(supabaseURL: config.projectURL, supabaseKey: config.anonKey)
    }
    
    private func currentUserID() async throws -> UUID {
        let session = try await client.auth.session
        return session.user.id
    }
    
    func fetchCreatorProfile() async throws -> CreatorProfile? {
        let userID = try await currentUserID() //get user id
        let profiles: [CreatorProfile] = try await client.database.from("creator_profiles").select().eq("user_id", value: userID).limit(1).execute().value
        return profiles.first
    }
    
    func saveCreatorProfile(displayName: String, niche: String?, profilePhotoURL: String?, bio: String?) async throws -> CreatorProfile {
        let userID = try await currentUserID()
        let data = CreatorProfileSaveData(userId: userID, displayName: displayName, niche: niche, profilePhotoURL: profilePhotoURL, bio: bio)
        return try await client.database.from("creator_profiles").upsert(data, onConflict: "user_id").select().single().execute().value
    }
    
    func fetchBrandProfile() async throws -> BrandProfile? {
        let userID = try await currentUserID()
        let profiles: [BrandProfile] = try await client.database.from("brand_profiles").select().eq("user_id",value: userID).limit(1).execute().value
        return profiles.first
    }
    
    func saveBrandProfile(
        companyName: String, brandIntro: String?,
        industries: [String]?, website: String?,
        location: String?, targetCreatorNiches: [String]?
    ) async throws -> BrandProfile {
        let userID = try await currentUserID()
        let data = BrandProfileSaveData(
            userId: userID, companyName: companyName,
            brandIntro: brandIntro, industries: industries, website: website,
            location: location, targetCreatorNiches: targetCreatorNiches
        )
        return try await client.database.from("brand_profiles").upsert(data, onConflict: "user_id").select().single().execute().value
        
    }
    
    func uploadCreatorPhoto(_ jpegData: Data) async throws -> String {
        let userID = try await currentUserID()
        let path = "\(userID.uuidString.lowercased())/profile.jpg"
        try await client.storage.from("profile-photos").upload(
            path: path,file: jpegData, options: FileOptions(contentType: "image/jpeg", upsert: true)
        )//uploads photo
        
        return try client.storage.from("profile-photos").getPublicURL(path: path).absoluteString //gets path of photo
    }
}

struct UnavailableProfileService: ProfileServicing {
    func fetchCreatorProfile() async throws -> CreatorProfile? {throw AuthValidationError.missingSupabaseConfig}
    func saveCreatorProfile(displayName: String, niche: String?, profilePhotoURL: String?, bio: String?) async throws -> CreatorProfile {
        throw AuthValidationError.missingSupabaseConfig
    }
    func fetchBrandProfile() async throws -> BrandProfile? { throw AuthValidationError.missingSupabaseConfig }
    func saveBrandProfile(
        companyName: String, brandIntro: String?,
        industries: [String]?, website: String?, location: String?, targetCreatorNiches: [String]?
    ) async throws -> BrandProfile { throw AuthValidationError.missingSupabaseConfig }
    func uploadCreatorPhoto(_ jpegData: Data) async throws -> String {
        throw AuthValidationError.missingSupabaseConfig
    }
}
