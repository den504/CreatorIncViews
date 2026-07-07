//
//  CreateAccountViewModel.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 29/06/2026.
//

import Foundation
import Combine

@MainActor
final class CreateAccountViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmedPassword = ""
    
    @Published private(set) var message: String?
    @Published private(set) var isLoading = false
    
    private let validator = AuthCredentialsValidator()
    private let authService: AuthServicing
    
    init(authService: AuthServicing, message: String? = nil) {
        self.authService = authService
        self.message = message
    }
    
    func createAccount(role: AccountRole) async -> Bool {
        message = nil
        isLoading = true
        defer {
            isLoading = false
        }
        
        do {
            try validator.validate(email: email, password: password, confirmedPassword: confirmedPassword)
            
        } catch {
            message = error.localizedDescription
            return false
        }
        
        do {
            try await authService.createAccount(email: email, password: password, role: role)
            message = "Account created. You can now log in."
            clearForm()
            return true
        } catch {
            message = error.localizedDescription //supabase would throw the error
            return false
        }
    }
    
    private func clearForm() {
        email = ""
        password = ""
        confirmedPassword = ""
    }
}
