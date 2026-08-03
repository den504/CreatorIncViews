//
//  CreatorShortValidator.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 01/08/2026.
//
import Foundation
import AVFoundation



enum CreatorShortValidationError: LocalizedError {
    case videoTooLong
    case compressionFailed
    
    var errorDescription: String? {
        switch self {
        case .videoTooLong: return "Videos must be 30 seconds or shorter"
        case .compressionFailed: return "Couldn't process this video. Try a different clip"
        }
        
    }
}

struct CreatorShortValidator {
    func validateDuration(url: URL) async throws {
        let duration = try await AVURLAsset(url: url).load(.duration).seconds
        guard duration <= 30 else { throw CreatorShortValidationError.videoTooLong}
    }
    
    func optionalText(_ value: String) -> String? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
