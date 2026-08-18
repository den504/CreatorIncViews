//
//  StreamConfig.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 18/08/2026.
//

import Foundation

struct StreamConfig {
    let apiKey: String
    
    static let apiKeyKey = "STREAM_API_KEY"
    
    static var config: StreamConfig?{
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: apiKeyKey) as? String else {
            return nil
        }
        return StreamConfig(apiKey: apiKey)
    }
}
