import Foundation
@testable import CreatorInc

enum IntegrationTestConfig {
    static var supabase: SupabaseConfig {
        let bundle = #bundle //have int test run on a different build from app
        guard 
            let urlString = bundle.object(forInfoDictionaryKey: "SUPABASE_URL") as? String,
            let anonKey = bundle.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String,
            let url = URL(string: urlString)
        else {
            fatalError("Missing test Supabase config")
        }
        return SupabaseConfig(projectURL: url, anonKey: anonKey)
    }
}
