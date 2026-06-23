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

    @State private var emailAddress = ""
    @State private var password = ""
    @State private var confirmedPassword = ""

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
                        text: $emailAddress
                    )

                    AccountSecureField(
                        title: "Password",
                        systemImage: "lock.fill",
                        text: $password
                    )

                    AccountSecureField(
                        title: "Confirm password",
                        systemImage: "lock.fill",
                        text: $confirmedPassword
                    )
                }
                .padding(.bottom, 18)

                DividerWithText("or continue with")
                    .padding(.bottom, 14)

                HStack(spacing: 12) {
                    SocialSignInButton(title: "Google", leadingText: "G")
                    SocialSignInButton(title: "Apple")
                }
                .padding(.bottom, 18)

                Button {
                } label: {
                    Text("Create Account")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryActionButtonStyle())
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
        CreateAccountView(selectedRole: .constant(.creator)) {}
    }
}
