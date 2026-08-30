//
//  CreatorIncTests.swift
//  CreatorIncTests
//
//  Created by Dennis Okafor on 01/07/2026.
//

import Testing
@testable import CreatorInc //lets test see the Creator Inc project

struct AuthCredentialsValidatorTests {
    private let validator = AuthCredentialsValidator()

    @Test("Rejects invalid credentials", arguments:[
        ("", "password123", "password123", AuthValidationError.missingEmail),
        ("a@b.com", "", "", .missingPassword),
        ("a@b.com", "1234567", "123456", .weakPassword),
        ("a@b.com", "password123", "different", .passwordMismatch)
    ])

    func rejectsInvalidCredentials(email:String, password: String, confirmation: String, expected: AuthValidationError){
        #expect(throws: expected){
            try validator.validate(email:email, password: password, confirmedPassword: confirmation)
        }

    }
    @Test("Accepts valid credentials")
    func acceptsValidCredentials() throws {
        try validator.validate(email: "a@b.com", password: "password123", confirmedPassword: "password123")
    }
}
