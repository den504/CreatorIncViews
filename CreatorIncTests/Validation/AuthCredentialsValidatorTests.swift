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

    @Test func emptyEmailThrowsMissingEmail() throws {
        #expect(throws: AuthValidationError.missingEmail) {
            try validator.validate(email: "", password: "password123", confirmedPassword: "password123")
        }
    }

    @Test func whitespaceOnlyEmailThrowsMissingEmail() throws {
        #expect(throws: AuthValidationError.missingEmail) {
            try validator.validate(email: " \n\t ", password: "password123", confirmedPassword: "password123")
        }
    }

    @Test func emptyPasswordThrowsMissingPassword() throws {
        #expect(throws: AuthValidationError.missingPassword) {
            try validator.validate(email: "person@example.com", password: "", confirmedPassword: "")
        }
    }

    @Test func passwordShorterThanEightCharactersThrowsWeakPassword() throws {
        #expect(throws: AuthValidationError.weakPassword) {
            try validator.validate(email: "person@example.com", password: "1234567", confirmedPassword: "1234567")
        }
    }

    @Test func eightCharacterPasswordIsAccepted() throws {
        try validator.validate(email: "person@example.com", password: "12345678", confirmedPassword: "12345678")
    }

    @Test func differentPasswordAndConfirmationThrowPasswordMismatch() throws {
        #expect(throws: AuthValidationError.passwordMismatch) {
            try validator.validate(email: "person@example.com", password: "password123", confirmedPassword: "different123")
        }
    }

    @Test func validCredentialsDoNotThrow() throws {
        try validator.validate(email: "person@example.com", password: "password123", confirmedPassword: "password123")
    }

    @Test func validationErrorsOccurInIntendedOrder() throws {
        #expect(throws: AuthValidationError.missingEmail) {
            try validator.validate(email: "", password: "", confirmedPassword: "different")
        }
        #expect(throws: AuthValidationError.missingPassword) {
            try validator.validate(email: "person@example.com", password: "", confirmedPassword: "different")
        }
        #expect(throws: AuthValidationError.weakPassword) {
            try validator.validate(email: "person@example.com", password: "short", confirmedPassword: "different")
        }
    }

    @Test func eachErrorProvidesCorrectUserFacingDescription() {
        #expect(AuthValidationError.missingEmail.errorDescription == "Enter your email address.")
        #expect(AuthValidationError.missingPassword.errorDescription == "Enter a password.")
        #expect(AuthValidationError.weakPassword.errorDescription == "Use at least 8 characters.")
        #expect(AuthValidationError.passwordMismatch.errorDescription == "Passwords do not match.")
        #expect(AuthValidationError.missingSupabaseConfig.errorDescription == "Supabase is not configured.")
    }
}
