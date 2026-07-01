//
//  CreatorIncTests.swift
//  CreatorIncTests
//
//  Created by Dennis Okafor on 01/07/2026.
//

import Testing
@testable import CreatorInc //lets test see the Creator Inc project

struct AuthCredentialsValidatorTests {

    @Test func emptyEmailThrowsMissingEmail() throws {
        let validator = AuthCredentialsValidator()
        #expect(throws: AuthValidationError.missingEmail) {
            try validator.validate(email: "", password: "password123", confirmedPassword: "password123")
        }
    }

}
