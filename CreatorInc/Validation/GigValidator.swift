//
//  GigValidator.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 25/07/2026.
//
import Foundation

enum GigValidationError : LocalizedError {
    case missingTitle
    case missingBrief
    case invalidBudget
    
    var errorDescription: String? {
        switch self {
        case .missingTitle: return "Add a gig title to continue."
        case .missingBrief: return "Add a brief to continue."
        case .invalidBudget: return "Enter a valid budget amount."
        }
    }
}

struct GigValidator {
    func validateTitle(_ value: String) throws -> String {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {throw GigValidationError.missingTitle}
        return trimmed
    }
    func validateBrief(_ value: String) throws -> String {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw GigValidationError.missingBrief }
        return trimmed
    }
    
    func validateBudget(_ text: String) throws -> Decimal {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let value = Decimal(string: trimmed), value > 0 else { throw GigValidationError.invalidBudget } //coverts string to decimal
        return value
    }
    func splitLines(_ text: String) -> [String] {
        text.split(separator: "\n").map {$0.trimmingCharacters(in: .whitespacesAndNewlines)}.filter {!$0.isEmpty}
        //split - changes multi-line text to array of strings
        //.map - ensures no whitespaces in each of the strings
        //.filter -ensures no empty string in the array
    }

}
