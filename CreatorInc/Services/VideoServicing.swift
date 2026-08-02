//
//  VideoServicing.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 01/08/2026.
//

import Foundation
import Supabase

protocol VideoServicing {
    func fetchShorts() async throws -> [CreatorShort]
    func uploadShort(videoData: Data, thumbnailData: Data) async throws -> CreatorShort
    func deleteShort(id: UUID) async throws
}


struct SupabaseVideoService: VideoServicing {
    private let client: SupabaseClient
    
    init(config: SupabaseConfig) {
        client = SupabaseClient(supabaseURL: config.projectURL, supabaseKey: config.anonKey)
    }
    
    private func currentUserID() async throws -> UUID {
        let session = try await client.auth.session
        return session.user.id
    }
    
    func fetchShorts() async throws -> [CreatorShort] {
        let userID = try await currentUserID()
        return try await client.database.from("creator_shorts")
            .select().eq("user_id", value: userID)
            .order("created_at", ascending: false).execute().value
    }
    
    //
    func uploadShort(videoData: Data, thumbnailData: Data) async throws -> CreatorShort {
        let userID = try await currentUserID()
        let shortUUID = UUID().uuidString.lowercased()
        let videoPath = "\(userID.uuidString.lowercased())/shorts/\(shortUUID).mp4"
        let thumbnailPath = "\(userID.uuidString.lowercased())/shorts/\(shortUUID).jpg"
        
        //upload video to storage
        try await client.storage.from("creator-videos").upload(path: videoPath, file: videoData, options: FileOptions(contentType: "video/mp4", upsert: true))
        try await client.storage.from("creator-videos").upload(
                    path: thumbnailPath, file: thumbnailData, options: FileOptions(contentType: "image/jpeg", upsert: true))
        
        //get urls from uploaded videos
        let videoURL = try client.storage.from("creator-videos").getPublicURL(path: videoPath).absoluteString
        let thumbnailURL = try client.storage.from("creator-videos").getPublicURL(path: thumbnailPath).absoluteString

        // send data to creator shorts tables
        let data = CreatorShortInsertData(userId: userID, videoURL: videoURL, thumbnailURL: thumbnailURL)
        return try await client.database.from("creator_shorts").insert(data).select().single().execute().value
        // returns creator object
    }
    
    func deleteShort(id: UUID) async throws {
        try await client.database.from("creator_shorts").delete().eq("id", value: id).execute()
    }

}


struct UnavailableVideoService: VideoServicing {
    func fetchShorts() async throws -> [CreatorShort] { throw AuthValidationError.missingSupabaseConfig }
    func uploadShort(videoData: Data, thumbnailData: Data) async throws -> CreatorShort {
        throw AuthValidationError.missingSupabaseConfig
    }
    func deleteShort(id: UUID) async throws {
        throw AuthValidationError.missingSupabaseConfig
    }

}

