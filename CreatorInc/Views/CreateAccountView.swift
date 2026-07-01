//
//  CreateAccountView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 16/06/2026.
//

import SwiftUI

struct CreateAccountView: View {
    @Binding var selectedRole: AccountRole
    let onBack: () -> Void
    
    @StateObject private var viewModel: CreateAccountViewModel
    
    //Keep it alive — SwiftUI recreates your view struct constantly (on every state change, every redraw). Without @StateObject, your VM would be thrown away and rebuilt each time. @StateObject tells SwiftUI to hold the VM in separate storage so it survives those redraws.
   // Hand it the initial value once — because SwiftUI only reads that initial value on the very first creation. If the view redraws and the expression inside @StateObject would produce a different object, SwiftUI ignores it — it already has one. So it only makes sense to set it up during init, where you're guaranteed to be in that first-creation moment.
    // @escaping just says don't consider this function until is needed - so
    // on init it would skip it - but when the user taps back it kicks off
    
    init(selectedRole: Binding<AccountRole>, onBack: @escaping () -> Void ){
        self._selectedRole = selectedRole
        self.onBack = onBack
        //SupabaseConfig and auth service passed here
        let config = SupabaseConfig.config
        let service: AuthServicing
        if let config {
            service = SupabaseAuthService(config: config)
        } else {
            service = UnavailableAuthService()
        }
        self._viewModel = StateObject(wrappedValue: CreateAccountViewModel(authService: service))
    }
    

    var body: some View {
        ZStack {
            Color.creatorBackground
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 8) {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 13, weight: .bold))
                            .frame(width: 30, height: 30)
                    }
                    .buttonStyle(CircleIconButtonStyle())

                    Text("Back")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.creatorMuted)
                }
                .padding(.bottom, 26)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Create account")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text("Join as a creator or brand")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.creatorMuted)
                }
                .padding(.bottom, 22)

                RoleSegmentedControl(selection: $selectedRole)
                    .padding(.bottom, 22)

                VStack(spacing: 12) {
                    AccountTextField(
                        title: "Email address",
                        systemImage: "envelope",
                        text: $viewModel.email
                    )

                    AccountSecureField(
                        title: "Password",
                        systemImage: "lock.fill",
                        text: $viewModel.password
                    )

                    AccountSecureField(
                        title: "Confirm password",
                        systemImage: "lock.fill",
                        text: $viewModel.confirmedPassword
                    )
                }
                .padding(.bottom, 18)
                if let message = viewModel.message {
                    Text(message)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.creatorSecondaryText)
                        .padding(.bottom, 12)
                }

                DividerWithText("or continue with")
                    .padding(.bottom, 14)

                HStack(spacing: 12) {
                    SocialSignInButton(title: "Google", leadingText: "G")
                    SocialSignInButton(title: "Apple")
                }
                .padding(.bottom, 18)

                Button {
                    Task {
                        await viewModel.createAccount()
                    }
                } label: {
                    Text(viewModel.isLoading ? "Creating..." : "Create Account")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryActionButtonStyle())
                .disabled(viewModel.isLoading)
                .padding(.bottom, 18)

                TermsText()
                    .frame(maxWidth: .infinity)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 34)
            .padding(.top, 18)
            .frame(maxWidth: 420, maxHeight: .infinity, alignment: .top)
        }
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView(
            selectedRole: .constant(.creator),
            onBack: {}
        )
    }
}
