import Foundation
import Combine

@MainActor
final class ShortsFeedViewModel: ObservableObject {
    @Published private(set) var shorts: [FeedShort] = []
    @Published private(set) var isLoading = false
    @Published private(set) var message: String?
    
    private let service: FeedServicing
    private let pageSize = 5
    private var remainingOffsets: [Int] = []
    private var hasLoaded = false
    
    init(service: FeedServicing) {
        self.service = service
    }

    func load() async {
        guard !hasLoaded else {
            return
        }
        
        hasLoaded = true
        message = nil
        await appendNextPage()
    }

    func loadMoreIfNeeded(after short: FeedShort) async {
        guard short.id == shorts.last?.id else {
            return
        }
        
        guard !isLoading, !remainingOffsets.isEmpty else {
            return
        }
        await appendNextPage()
    }



    private func fetchAndAppend() async throws {
        while let startingPosition = remainingOffsets.last {
            
            let newShorts = try await service.fetchFeed(offset: startingPosition, limit: pageSize)
            remainingOffsets.removeLast()
            if newShorts.isEmpty {
                continue
            }
            shorts.append(contentsOf: newShorts)
            return

        }
    }

    private func appendNextPage() async {
        isLoading = true
        message = nil
        
        defer {
            isLoading = false
        }
        
        do {
            if remainingOffsets.isEmpty {
                try await planPages()
            }
            
            try await fetchAndAppend()
        } catch {
            message = error.localizedDescription
            hasLoaded = false
        }
    }


    private func planPages() async throws {
        let total = try await service.fetchFeedCount()
        remainingOffsets = DiscoverPagePlanner.shuffledOffsets(totalCount: total, pageSize: pageSize)
    }
}