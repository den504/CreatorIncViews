//
//  ProfileValidator.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 18/07/2026.
//

import Foundation

enum ProfileValidationError: LocalizedError { 
    case missingCreatorName
    case missingCompanyName
    var errorDescription: String? {
            switch self {
            case .missingCreatorName: return "Add your full name to continue."
            case .missingCompanyName: return "Add your company name to continue."
            }
        }
}

struct ProfileValidator {
    func validateCreatorName (_ name: String) throws -> String {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {throw ProfileValidationError.missingCreatorName}
        return trimmedName
    }
    func validateCompanyName(_ name: String) throws -> String {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { throw ProfileValidationError.missingCompanyName }
        return trimmedName
    }
    func optionalText(_ value: String) -> String? { 
        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedValue.isEmpty ? nil : trimmedValue
    }

    func optionalList(_ values: [String]) -> [String]? {
        values.isEmpty ? nil : values
    }
}
