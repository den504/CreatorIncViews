//
//  LoginView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 04/07/2026.
//

import SwiftUI

struct LoginView: View {
    let onBack: () -> Void
    let message: String?
    let onLoginSucceeded: (LoginResult) -> Void
    
    @StateObject private var viewModel: LoginViewModel
    
    init(onBack: @escaping () -> Void, message: String?, initialEmail: String = "", onLoginSucceeded: @escaping(LoginResult) -> Void) {
        self.onBack = onBack
        self.message = message
        self.onLoginSucceeded = onLoginSucceeded
        let config = SupabaseConfig.config
        let service: AuthServicing
        
        if let config {
            service = SupabaseAuthService(config: config)
        }else {
            service = UnavailableAuthService()
        }
        self._viewModel = StateObject(
            wrappedValue: LoginViewModel(authService: service, message: message, initialEmail: initialEmail)
        )
    }
    
    
    var body: some View {
        ZStack {
            Color.creatorBackground.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 8){
                    Button(action: onBack){
                        Image(systemName: "chevron.left")
                            .font(.system(size: 13, weight: .bold))
                            .frame(width: 30, height:30)
                    }.buttonStyle(CircleIconButtonStyle())
                    Text("Back")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.creatorMuted)
                }.padding(.bottom, 26)
                
                VStack(alignment: .leading, spacing: 6){
                    Text("Log in")
                        .font(.system(size: 28, weight: .bold, design: .rounded)).foregroundStyle(.white)
                    Text("Welcome back to CreatorInc").font(.system(size: 14, weight: .semibold)).foregroundStyle(Color.creatorMuted)
                }.padding(.bottom, 22)
                
                VStack(spacing: 12){
                    AccountTextField(title: "Email address", systemImage: "envelope", text: $viewModel.email)
                    AccountSecureField(title: "Password", systemImage: "lock.fill", text: $viewModel.password)
                }.padding(.bottom, 18)
                if let message = viewModel.message {
                    Text(message).font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.creatorSecondaryText)
                        .padding(.bottom, 12)
                }
                    
                Button {
                    Task {
                        
                        if let result = await viewModel.login() {
                            onLoginSucceeded(result)
                        }
                    }
                } label: {
                    Text(viewModel.isLoading ? "Logging in...": "Log In").frame(maxWidth: .infinity)
                }.buttonStyle(PrimaryActionButtonStyle()).disabled(viewModel.isLoading)
                Spacer(minLength: 0)

            }.padding(.horizontal, 34)
                .padding(.top, 18)
                .frame(maxWidth:420, maxHeight: .infinity, alignment: .top)
        }
    }
}
