//
//  LoginViewModel.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 05/07/2026.
//

import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    @Published private(set) var message: String?
    @Published private(set) var isLoading = false
    
    private let validator = AuthCredentialsValidator()
    private let authService: AuthServicing
    
    init(authService: AuthServicing, message: String? = nil){
        self.authService = authService
        self.message = message
    }
    
    func login() async -> Bool {
        message = nil
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            try validator.validate(email: email, password: password, confirmedPassword: password)
        } catch {
            message = error.localizedDescription
            return false
        }
        
        do {
            try await authService.login(email: email, password: password)
            clearForm() //remove/test if this makes sense when you know where the user goes after Login
            return true
            
        } catch {
            message = error.localizedDescription
            return false
        }
        
    }
    
    private func clearForm() { //Might Remove this after I reroute Login to a different views
        email = ""
        password = ""
    }
}
