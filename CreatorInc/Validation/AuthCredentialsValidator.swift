//
//  AuthCredentialsValidator.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 27/06/2026.
//

import Foundation

//localizedError protocol, enables the
//enum to called using example error.localizedDescription
//to get the exact error description, avoids replicating if/else
//logic on the views , simple do
//let error = AuthValidation.missingEmail
//print(error.localizedDescription)
enum AuthValidationError: LocalizedError {
    case missingEmail
    case missingPassword
    case weakPassword
    case passwordMismatch
    case missingSupabaseConfig
    
  
    
    var errorDescription: String? {
        switch self {
        case .missingEmail:
            return "Enter your email address."
        case .missingPassword:
            return "Enter a password."
        case .weakPassword:
            return "Use at least 8 characters."
        case .passwordMismatch:
            return "Passwords do not match."
        case .missingSupabaseConfig:
            return "Supabase is not configured."
        }
    

    }
    
}

struct AuthCredentialsValidator {
    
    func validate(email: String, password: String, confirmedPassword: String) throws {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedEmail.isEmpty else {
            throw AuthValidationError.missingEmail
        }
        
        guard !password.isEmpty else {
            throw AuthValidationError.missingPassword
        }
        
        guard password.count >= 8 else {
            throw AuthValidationError.weakPassword
        }
        
        guard password == confirmedPassword else {
            throw AuthValidationError.passwordMismatch
        }
    }
}
