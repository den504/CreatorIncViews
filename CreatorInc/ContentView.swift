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
    @State private var signOutErrorMessage = ""
    @State private var isShowingSignOutError = false

    var body: some View {
    
        Group {
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
                BuildCreatorProfileView(profile: creatorProfile, onBack: {activeScreen = creatorProfile == nil ? .login : .creatorProfile }, onProfileSaved: {profile in
                    creatorProfile = profile
                    activeScreen = .creatorProfile //from the case statement
                })
            case .buildBrandProfile:
                BuildBrandProfileView(profile: brandProfile, onBack: {activeScreen = brandProfile == nil ? .login : .brandProfile}, onProfileSaved: {profile in brandProfile = profile
                    activeScreen = .brandProfile
                })
            case .creatorHome:
                CreatorMainTabView(onProfileTapped: {activeScreen = .creatorProfile}, onSignOut: { Task { await signOut() } })
            case .creatorProfile:
                if let creatorProfile { //reused from BuildCreatorProfileView
                    CreatorProfileView(profile: creatorProfile, onEdit: {activeScreen = .buildCreatorProfile}, onBack: {activeScreen = .creatorHome})
                }
            case .brandProfile:
                if let brandProfile { // [SoC → parent state → saved brand]
                    BrandProfileView(
                        profile: brandProfile,
                        onEdit: { activeScreen = .buildBrandProfile }, onBack: {activeScreen = .brandHome})
                }
            case .loadingProfile:
                ProgressView("Loading profile")
                
            case .brandHome:
                BrandMainTabView(onProfileTapped: {activeScreen = .brandProfile}, onSignOut: { Task { await signOut() } })
                
            }
            
        }.background(Color.creatorBackground.ignoresSafeArea())
            .preferredColorScheme(activeScreen.isPostLogin ? .dark : nil)


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
                if let creatorProfile {
                    await connectChat(userId: creatorProfile.userId, displayName: creatorProfile.displayName, photoURL: creatorProfile.profilePhotoURL)
                }
                activeScreen = creatorProfile == nil ? .buildCreatorProfile : .creatorHome

            case .brand:
                brandProfile = try await service.fetchBrandProfile()
                if let brandProfile {
                    await connectChat(userId: brandProfile.userId, displayName: brandProfile.companyName, photoURL: nil)
                }
                activeScreen = brandProfile == nil ? .buildBrandProfile : .brandHome
            }
        } catch {
            loginMessage = error.localizedDescription
            activeScreen = .login
        }
    }
    
    private func signOut() async {
        guard let config = SupabaseConfig.config else {
            signOutErrorMessage = "Supabase is unavailable."
            isShowingSignOutError = true
            return
        }

        do {
            try await SupabaseAuthService(config: config).signOut()
            if let streamConfig = StreamConfig.config {
                await StreamChatService(supabaseConfig: config, streamConfig: streamConfig).disconnectUser()
            }
            creatorProfile = nil
            brandProfile = nil
            loginMessage = nil
            activeScreen = .login
        } catch {
            signOutErrorMessage = error.localizedDescription
            isShowingSignOutError = true
        }
    }
    
    private func connectChat(userId: UUID, displayName: String, photoURL: String?) async {
        guard let supabaseConfig = SupabaseConfig.config, let streamConfig = StreamConfig.config else{
            return
        }
        let chatService = StreamChatService(supabaseConfig: supabaseConfig, streamConfig: streamConfig)
        do {
            try await chatService.connectUser(id: userId, name: displayName, imageURL: photoURL.flatMap(URL.init))
        }catch {
            print("Stream connect failed", error)
            
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
    case brandHome
    
    var isPostLogin: Bool {
        switch self {
        case .welcome, .createAccount, .login: return false
        default: return true
        }
    }
}



