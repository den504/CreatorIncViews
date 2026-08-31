import Testing
import Foundation
@testable import CreatorInc

struct IntergrationTestConfigTests {
    @Test("Test Supabase config loads from test bundle")
    func loadsTestConfig() {
        let config = IntegrationTestConfig.supabase
        #expect(config.projectURL.absoluteString.contains("supabase.co"))
        #expect(!config.anonKey.isEmpty)
    }
}
