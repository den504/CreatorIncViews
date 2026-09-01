import Foundation
import Combine

@MainActor
final class CreatorShortsStripViewModel: ObservableObject {
    @Published private(set) var shorts: [CreatorShort] = []
    @Published private(set) var isLoading = false
    @Published private(set) var message: String?
    private let service: FeedServicing

    init(service: FeedServicing) {
        self.service = service
    }

    func load(for userId: UUID) async {
        isLoading = true
        message = nil
        defer { isLoading = false }
        do {
            shorts = try await service.fetchShorts(for: userId)
        } catch {
            message = error.localizedDescription
        }
    }
}