import Foundation

nonisolated struct FeedShort: Identifiable, Codable, Sendable {
    let id: UUID
    let userId: String
    let videoURL: URL
    let thumbnailURL: URL
    let description: String?
    let createdAt: Date
    let displayName: String
    let niche: String?
    let profilePhotoURL: String?

    enum CodingKeys: String, CodingKey {
        case id,description, niche
        case userId = "user_id"
        case videoURL = "video_url"
        case thumbnailURL = "thumbnail_url"
        case createdAt = "created_at"
        case displayName = "display_name"
        case profilePhotoURL = "profile_photo_url"
    }
}