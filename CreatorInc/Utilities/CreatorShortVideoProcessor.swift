//
//  CreatorShortVideoProcessor.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 01/08/2026.
//

import AVFoundation
import Foundation
import UIKit //needed for UIiMAGE

enum CreatorShortVideoProcessor {
    static func compress(url: URL) async throws -> URL {
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".mp4")
        guard let session = AVAssetExportSession(asset: AVURLAsset(url: url), presetName: AVAssetExportPresetMediumQuality) else {
            throw CreatorShortValidationError.compressionFailed }
        try await session.export(to: outputURL, as: .mp4)
        return outputURL
        }
    
    static func thumbnail(from url: URL) async throws -> Data {
        let generator = AVAssetImageGenerator(asset: AVURLAsset(url: url))
        generator.appliesPreferredTrackTransform = true
        let (cgImage, _) = try await generator.image(at: .zero)
        
        guard let data = UIImage(cgImage: cgImage).jpegData(compressionQuality: 0.8) else {
            throw CreatorShortValidationError.compressionFailed
        }
        return data
    }

}

