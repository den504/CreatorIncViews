//
//  ContentView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 16/06/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var activeScreen: ActiveScreen = .welcome
    @State private var selectedRole: AccountRole = .creator
    @State private var loginMessage: String?
    @State private var lastEmail: String = ""

    var body: some View {
        switch activeScreen {
        case .welcome:
            WelcomeView(
                onRoleSelected: {
                    role in
                    selectedRole = role
                    activeScreen = .createAccount
                },
                onLoginSelected: { loginMessage = nil
                    activeScreen = .login
                }
            )
        case .createAccount:
            CreateAccountView(
                selectedRole: $selectedRole,
                onBack: { activeScreen = .welcome },
                onAccountCreated: { loginMessage = "Account created. You can now log in."
                    activeScreen = .login }
            )
        case .login:
            LoginView(
                onBack: { activeScreen = .welcome },
                message: loginMessage,
                initialEmail: lastEmail,
                onLoginSucceeded: { result in
                    lastEmail = result.email
                    activeScreen = result.role == .creator ? .buildCreatorProfile : .buildBrandProfile
                }
            )
        case .buildCreatorProfile:
            BuildCreatorProfileView(onBack: {activeScreen = .login})
        case .buildBrandProfile:
            BuildBrandProfileView(onBack: {activeScreen = .login})
            
        }
    }
}

private enum ActiveScreen {
    case welcome
    case createAccount
    case login
    case buildCreatorProfile
    case buildBrandProfile
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
