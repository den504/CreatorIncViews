//
//  CreatorShortsViewModel.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 01/08/2026.
//

import Foundation
import Combine

@MainActor
class CreatorShortsViewModel: ObservableObject {
    @Published private(set) var shorts: [CreatorShort] = []
    @Published private(set) var isLoading = false
    @Published var message: String?
    private let videoService: VideoServicing
    private let validator = CreatorShortValidator()
    
    init(videoService: VideoServicing) {
        self.videoService = videoService
    }
    
    func loadShorts() async {
        isLoading = true
        defer { isLoading = false }
        do {
            shorts = try await videoService.fetchShorts()
        } catch {
            message = error.localizedDescription
        }
    }
    
    func uploadShort (from url: URL, description: String) async { //url --> //local path on your device
        message = nil
        isLoading = true
        
        defer {
            isLoading = false
        }
        do {
            try await validator.validateDuration(url: url)
            let description = validator.optionalText(description)
            let compressedURL = try await CreatorShortVideoProcessor.compress(url: url)
            let videoData = try Data(contentsOf: compressedURL) //from foundations - reads raw bytes off disk given a local file url
            let thumbnailData = try await CreatorShortVideoProcessor.thumbnail(from: url)
            let newShort = try await videoService.uploadShort(videoData: videoData, thumbnailData: thumbnailData, description: description)
            shorts.insert(newShort, at: 0) //videos stored locally
        } catch {
            message = error.localizedDescription
        }
    }
    
    func deleteShort(_ short: CreatorShort) async {
        do {
            try await videoService.deleteShort(id: short.id)
            shorts.removeAll { $0.id == short.id }
        } catch {
            message = error.localizedDescription
        }
    }


}
