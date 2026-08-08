//
//  DiscoverViewModel.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 04/08/2026.
//

import Combine
import Foundation


nonisolated enum DiscoverSection: String, CaseIterable, Identifiable {
    case creators = "Creators"
    case gigs = "Gigs"

    var id: Self { self }
}


nonisolated enum DiscoverPagePlanner {
    static func shuffledOffsets( totalCount: Int, pageSize: Int) -> [Int] {
        guard totalCount > 0, pageSize > 0 else {
            return []
        }
        return Array(stride(from: 0, to: totalCount, by: pageSize)).shuffled()
    }
}


@MainActor
final class DiscoverViewModel: ObservableObject {
    @Published var selectedSection: DiscoverSection = .creators

    @Published private(set) var creators: [CreatorProfile] = []
    @Published private(set) var gigs: [Gig] = []
    @Published private(set) var isLoadingCreators = false
    @Published private(set) var isLoadingGigs = false
    @Published private(set) var message: String?

    private let service: DiscoverServicing
    private let pageSize = 5

    private var remainingCreatorOffsets: [Int] = []
    private var seenCreatorIDs: Set<UUID> = []
    private var hasLoaded = false

    init(service: DiscoverServicing) {
        self.service = service
    }

    func load() async {
        guard !hasLoaded else {
            return
        }

        hasLoaded = true
        message = nil

        await loadInitialCreators()
        await loadOpenGigs()
    }

    private func loadInitialCreators() async {
        isLoadingCreators = true
        defer {
            isLoadingCreators = false
        }

        do {
            //ascertain number of creators so you can understand how to chunk them
            let creatorCount = try await service.fetchCreatorCount()

            remainingCreatorOffsets =
                DiscoverPagePlanner.shuffledOffsets(
                    totalCount: creatorCount,
                    pageSize: pageSize
                ) // create an array of starting postions of chunk size 5 then shuffle

            try await appendNextCreatorPage()
        } catch {
            message = error.localizedDescription
        }
    }

    func loadMoreIfNeeded(after creator: CreatorProfile) async {
        guard creator.id == creators.last?.id else {
            return
        }

        guard !isLoadingCreators else {
            return
        }

        guard !remainingCreatorOffsets.isEmpty else {
            return
        }

        isLoadingCreators = true
        defer {
            isLoadingCreators = false
        }

        do {
            try await appendNextCreatorPage()
        } catch {
            message = error.localizedDescription
        }
    }

    
    
    private func appendNextCreatorPage() async throws { //from what position of the array should i call
        while let startingPosition = remainingCreatorOffsets.popLast() {//takes the last number from the array
            do {
                let page = try await service.fetchCreators(//take the 5 upward from the chunk selected
                    offset: startingPosition,
                    limit: pageSize
                )

                let shuffledCreators = page.shuffled()

                guard !shuffledCreators.isEmpty else {
                    continue
                }

                creators.append(contentsOf: shuffledCreators)// json array of creators
                return

            } catch {
                remainingCreatorOffsets.append(startingPosition) // as remainingCreatorOffsets.popLast() takes last position, if it errors
                //append puts the last position back
                throw error
            }
        }
    }

    private func loadOpenGigs() async {
        isLoadingGigs = true
        defer {
            isLoadingGigs = false
        }

        do {
            gigs = try await service.fetchOpenGigs()
        } catch {
            message = error.localizedDescription
        }
    }
}
