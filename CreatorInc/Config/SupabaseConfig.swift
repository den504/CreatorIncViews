//
//  SupabaseConfig.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 26/06/2026.
//

import Foundation

struct SupabaseConfig {
    let projectURL: URL
    let anonKey: String
    
    static let projectURLKey = "SUPABASE_URL"
    static let anonKeyKey = "SUPABASE_ANON_KEY"
    
    //add supa base url cred on the app package that runs on the iphone
    static var config: SupabaseConfig? {
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: projectURLKey) as? String else {
            return nil
        }
        guard let projectURL = URL(string: urlString) else {
            return nil
        }
        guard let anonKey = Bundle.main.object(forInfoDictionaryKey: anonKeyKey) as? String else {
            return nil
        }

        return SupabaseConfig(projectURL: projectURL, anonKey: anonKey)
    }
}
