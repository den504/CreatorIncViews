//
//  ProfileImageProcessor.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 18/07/2026.
//

import UIKit

enum ProfileImageProcessor {
    static func jpegData(from data: Data) -> Data? {
        guard let image = UIImage(data: data) else { return nil }
        let size = CGSize(width: 1000, height: 1000)
        let thumbnail = image.preparingThumbnail(of: size) ?? image
        return thumbnail.jpegData(compressionQuality: 0.8)
    }
}
