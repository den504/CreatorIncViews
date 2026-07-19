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
    @State private var creatorProfile: CreatorProfile?
    @State private var brandProfile: BrandProfile?

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
                    loginMessage = nil
                    activeScreen = .loadingProfile
                    Task { await loadProfile(for: result.role) }
                }
            )
        case .buildCreatorProfile:
            BuildCreatorProfileView(profile: creatorProfile, onBack: {activeScreen = .login }, onProfileSaved: {profile in
                creatorProfile = profile
                activeScreen = .creatorProfile //from the case statement
            })
        case .buildBrandProfile:
            BuildBrandProfileView(profile: brandProfile, onBack: {activeScreen = brandProfile == nil ? .login : .brandProfile}, onProfileSaved: {profile in brandProfile = profile
            activeScreen = .brandProfile
        })
        case .creatorHome:
            CreatorMainTabView(onLogin: { activeScreen = .login })
        case .creatorProfile:
            if let creatorProfile { //reused from BuildCreatorProfileView
                CreatorProfileView(profile: creatorProfile, onEdit: {activeScreen = .buildCreatorProfile}, onBack: {activeScreen = .creatorHome})
            }
        case .brandProfile:
            if let brandProfile { // [SoC → parent state → saved brand]
                BrandProfileView(
                    profile: brandProfile,
                    onEdit: { activeScreen = .buildBrandProfile }, onBack: {activeScreen = .creatorHome})
            }
        case .loadingProfile:
            ProgressView("Loading profile")
            
        }

    }
    
    
    private func loadProfile(for role: AccountRole) async { // [SoC → routing → profile lookup]
        guard let config = SupabaseConfig.config else {
            loginMessage = "Supabase is unavailable."
            activeScreen = .login
            return
        }

        let service = SupabaseProfileService(config: config)
        do {
            switch role {
            case .creator:
                creatorProfile = try await service.fetchCreatorProfile()
                activeScreen = creatorProfile == nil ? .buildCreatorProfile : .creatorProfile

            case .brand:
                brandProfile = try await service.fetchBrandProfile()
                activeScreen = brandProfile == nil ? .buildBrandProfile : .brandProfile
            }
        } catch {
            loginMessage = error.localizedDescription
            activeScreen = .login
        }
    }
}

private enum ActiveScreen {
    case welcome
    case createAccount
    case login
    case buildCreatorProfile
    case buildBrandProfile
    case creatorProfile
    case brandProfile
    case loadingProfile
    case creatorHome
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
