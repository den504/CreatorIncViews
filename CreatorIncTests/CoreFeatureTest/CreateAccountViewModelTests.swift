//
//  CreateAccountViewModelTests.swift
//  CreatorIncTests
//

import Foundation
import Testing
@testable import CreatorInc

@MainActor
struct CreateAccountViewModelTests {

    @Test func successfulCreationPassesExactInputsAndClearsForm() async throws {
        let service = AuthServiceSpy()
        let viewModel = CreateAccountViewModel(authService: service)
        viewModel.email = "brand@example.com"
        viewModel.password = "password123"
        viewModel.confirmedPassword = "password123"

        let didCreateAccount = await viewModel.createAccount(role: .brand)
        let call = try #require(service.createAccountCalls.first)

        #expect(didCreateAccount)
        #expect(service.createAccountCalls.count == 1)
        #expect(call.email == "brand@example.com")
        #expect(call.password == "password123")
        #expect(call.role == .brand)
        #expect(viewModel.email.isEmpty)
        #expect(viewModel.password.isEmpty)
        #expect(viewModel.confirmedPassword.isEmpty)
        #expect(viewModel.message == "Account created. You can now log in.")
        #expect(!viewModel.isLoading)
    }

    @Test func serviceFailureRetainsFormAndDisplaysError() async {
        let service = AuthServiceSpy()
        service.createAccountError = TestError.creationFailed
        let viewModel = CreateAccountViewModel(authService: service)
        viewModel.email = "creator@example.com"
        viewModel.password = "password123"
        viewModel.confirmedPassword = "password123"

        let didCreateAccount = await viewModel.createAccount(role: .creator)

        #expect(!didCreateAccount)
        #expect(service.createAccountCalls.count == 1)
        #expect(viewModel.email == "creator@example.com")
        #expect(viewModel.password == "password123")
        #expect(viewModel.confirmedPassword == "password123")
        #expect(viewModel.message == TestError.creationFailed.errorDescription)
        #expect(!viewModel.isLoading)
    }

 
}

@MainActor
private final class AuthServiceSpy: AuthServicing {
    struct CreateAccountCall {
        let email: String
        let password: String
        let role: AccountRole
    }

    private(set) var createAccountCalls: [CreateAccountCall] = []
    var createAccountError: (any Error)?

    func createAccount(email: String, password: String, role: AccountRole) async throws {
        createAccountCalls.append(.init(email: email, password: password, role: role))

        if let createAccountError {
            throw createAccountError
        }
    }

    func login(email: String, password: String) async throws -> LoginResult {
        throw TestError.unexpectedLogin
    }
    
    func signOut() async throws {}
}

private enum TestError: LocalizedError {
    case creationFailed
    case unexpectedLogin

    var errorDescription: String? {
        switch self {
        case .creationFailed: "Account creation failed."
        case .unexpectedLogin: "Login should not be called."
        }
    }
}
