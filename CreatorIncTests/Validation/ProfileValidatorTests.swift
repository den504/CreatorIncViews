//
//  ProfileValidatorTests.swift
//  CreatorIncTests
//

import Testing
@testable import CreatorInc

struct ProfileValidatorTests {
    private let validator = ProfileValidator()

    @Test func emptyCreatorNameThrowsMissingCreatorName() {
        #expect(throws: ProfileValidationError.missingCreatorName) {
            try validator.validateCreatorName("")
        }
    }

    @Test func whitespaceOnlyCreatorNameThrowsMissingCreatorName() {
        #expect(throws: ProfileValidationError.missingCreatorName) {
            try validator.validateCreatorName(" \n\t ")
        }
    }

    @Test func creatorNameIsTrimmed() throws {
        let name = try validator.validateCreatorName("  Ada Lovelace \n")

        #expect(name == "Ada Lovelace")
    }

    @Test func emptyCompanyNameThrowsMissingCompanyName() {
        #expect(throws: ProfileValidationError.missingCompanyName) {
            try validator.validateCompanyName("")
        }
    }

    @Test func whitespaceOnlyCompanyNameThrowsMissingCompanyName() {
        #expect(throws: ProfileValidationError.missingCompanyName) {
            try validator.validateCompanyName(" \n\t ")
        }
    }

    @Test func companyNameIsTrimmed() throws {
        let name = try validator.validateCompanyName("  Creator Inc \n")

        #expect(name == "Creator Inc")
    }

    @Test func emptyOptionalTextReturnsNil() {
        #expect(validator.optionalText("") == nil)
    }

    @Test func whitespaceOnlyOptionalTextReturnsNil() {
        #expect(validator.optionalText(" \n\t ") == nil)
    }

    @Test func optionalTextIsTrimmed() {
        #expect(validator.optionalText("  Travel creator \n") == "Travel creator")
    }

    @Test func emptyOptionalListReturnsNil() {
        #expect(validator.optionalList([]) == nil)
    }

    @Test func nonEmptyOptionalListIsPreserved() {
        let values = ["Travel", "Food"]

        #expect(validator.optionalList(values) == values)
    }

    @Test func errorsProvideCorrectUserFacingDescriptions() {
        #expect(ProfileValidationError.missingCreatorName.errorDescription == "Add your full name to continue.")
        #expect(ProfileValidationError.missingCompanyName.errorDescription == "Add your company name to continue.")
    }
}
