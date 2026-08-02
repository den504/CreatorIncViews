//
//  CreateAccountViewModelTests.swift
//  CreatorIncTests
//

import Foundation
import Testing
@testable import CreatorInc

@MainActor
struct CreateAccountViewModelTests {
    @Test func initializationUsesEmptyFieldsAndProvidedMessage() {
        let viewModel = CreateAccountViewModel(
            authService: AuthServiceSpy(),
            message: "Welcome"
        )

        #expect(viewModel.email.isEmpty)
        #expect(viewModel.password.isEmpty)
        #expect(viewModel.confirmedPassword.isEmpty)
        #expect(viewModel.message == "Welcome")
        #expect(!viewModel.isLoading)
    }

    @Test func validationFailureDoesNotCallService() async {
        let service = AuthServiceSpy()
        let viewModel = CreateAccountViewModel(authService: service)
        viewModel.password = "password123"
        viewModel.confirmedPassword = "password123"

        let didCreateAccount = await viewModel.createAccount(role: .creator)

        #expect(!didCreateAccount)
        #expect(service.createAccountCalls.isEmpty)
        #expect(viewModel.message == AuthValidationError.missingEmail.errorDescription)
        #expect(!viewModel.isLoading)
    }

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

    @Test func loadingIsTrueWhileServiceRequestIsPending() async {
        let service = AuthServiceSpy()
        service.shouldSuspendCreateAccount = true
        let viewModel = CreateAccountViewModel(authService: service)
        viewModel.email = "creator@example.com"
        viewModel.password = "password123"
        viewModel.confirmedPassword = "password123"

        let operation = Task { @MainActor in
            await viewModel.createAccount(role: .creator)
        }
        await Task.yield()

        #expect(service.createAccountCalls.count == 1)
        #expect(viewModel.isLoading)

        service.resumeCreateAccount()
        let didCreateAccount = await operation.value

        #expect(didCreateAccount)
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
    var shouldSuspendCreateAccount = false
    private var createAccountContinuation: CheckedContinuation<Void, Never>?

    func createAccount(email: String, password: String, role: AccountRole) async throws {
        createAccountCalls.append(.init(email: email, password: password, role: role))

        if shouldSuspendCreateAccount {
            await withCheckedContinuation { continuation in
                createAccountContinuation = continuation
            }
        }

        if let createAccountError {
            throw createAccountError
        }
    }

    func login(email: String, password: String) async throws -> LoginResult {
        throw TestError.unexpectedLogin
    }

    func resumeCreateAccount() {
        createAccountContinuation?.resume()
        createAccountContinuation = nil
    }
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
