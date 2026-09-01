import Foundation
import Supabase

protocol FeedServicing {
    func fetchFeed(offset: Int, limit: Int) async throws -> [FeedShort]
    func fetchShorts(for userId: UUID) async throws -> [CreatorShort]
    func fetchFeedCount() async throws -> Int

}

struct SupabaseFeedService: FeedServicing {
    private let client: SupabaseClient
    
    init(config: SupabaseConfig) {
        client = SupabaseClient(supabaseURL: config.projectURL, supabaseKey: config.anonKey)
    }
    //all shorts for home screen , * gets all fields on shorts
    func fetchFeed(offset: Int, limit: Int) async throws -> [FeedShort] {
        try await client.database.from("creator_shorts")
        .select("*,...creator_profiles!inner(display_name,niche,profile_photo_url)")
        .order("created_at", ascending: false)
        .range(from: offset, to: offset + limit - 1)
        .execute().value
    }
    
    //creator shorts for discover
    func fetchShorts(for userId: UUID) async throws -> [CreatorShort] {
        try await client.database.from("creator_shorts")
        .select()
        .eq("user_id", value: userId)
        .order("created_at", ascending: false)
        .execute().value
    }

    func fetchFeedCount() async throws -> Int {
        let response: PostgrestResponse<Void> = try await client.database.from("creator_shorts")
        .select("id",head: true, count: .exact)
        .execute()
        return response.count ?? 0
    }

}

struct UnavailableFeedService: FeedServicing {
    func fetchFeed(offset: Int, limit: Int) async throws -> [FeedShort] {
        throw AuthValidationError.missingSupabaseConfig
    }
    
    func fetchShorts(for userId: UUID) async throws -> [CreatorShort] {
        throw AuthValidationError.missingSupabaseConfig
    }
    
    func fetchFeedCount() async throws -> Int {
        throw AuthValidationError.missingSupabaseConfig
    }
}