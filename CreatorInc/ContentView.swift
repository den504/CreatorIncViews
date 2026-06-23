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

    var body: some View {
        switch activeScreen {
        case .welcome:
            WelcomeView { role in
                selectedRole = role
                activeScreen = .createAccount
            }
        case .createAccount:
            CreateAccountView(selectedRole: $selectedRole) {
                activeScreen = .welcome
            }
        }
    }
}

private enum ActiveScreen {
    case welcome
    case createAccount
}

enum AccountRole: String, CaseIterable, Identifiable {
    case creator = "Creator"
    case brand = "Brand"

    var id: String { rawValue }
}

struct WelcomeView: View {
    let onRoleSelected: (AccountRole) -> Void

    var body: some View {
        ZStack {
            Color.creatorBackground
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                Spacer(minLength: 32)

                LogoMark()
                    .padding(.bottom, 18)

                VStack(alignment: .leading, spacing: 8) {
                    Text("CreatorsInc")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text("Connect creators with brands.\nManage campaigns smarter.")
                        .font(.system(size: 17, weight: .semibold))
                        .lineSpacing(4)
                        .foregroundStyle(Color.creatorMuted)
                }

                Spacer(minLength: 50)

                MatchPreviewCard()

                Spacer(minLength: 34)

                RoleSelectionButtons(onSelect: onRoleSelected)

                HStack(spacing: 4) {
                    Text("Already have an account?")
                        .foregroundStyle(Color.creatorMuted)

                    Button("Log in") {
                    }
                    .fontWeight(.bold)
                    .foregroundStyle(Color.creatorPrimary)
                }
                .font(.system(size: 15, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.top, 22)

                Spacer(minLength: 28)
            }
            .padding(.horizontal, 34)
            .frame(maxWidth: 420)
        }
    }
}

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

private struct LogoMark: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(Color.creatorPrimary)
            .frame(width: 64, height: 64)
            .overlay {
                Text("C")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            }
            .shadow(color: .creatorPrimary.opacity(0.25), radius: 18, y: 10)
    }
}

private struct MatchPreviewCard: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.creatorPanel)

            VStack {
                ProfileMetricCard()
                    .frame(maxWidth: .infinity, alignment: .leading)

                BrandMatchCard()
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 22)
        }
        .frame(height: 220)
    }
}

private struct ProfileMetricCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Jess Miller")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)

            Text("Travel & Lifestyle")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.creatorSubtle)

            Text("120K")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color.creatorPrimary)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 15)
        .frame(width: 136, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.creatorCard)
                .overlay {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                }
        }
    }
}

private struct BrandMatchCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("NaturSun")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)

            Text("Skincare Brand")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.creatorSubtle)

            Label("Matched", systemImage: "checkmark")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color.creatorPrimary)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 15)
        .frame(width: 146, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.creatorCard)
                .overlay {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                }
        }
        .offset(y: -6)
    }
}

private struct RoleSelectionButtons: View {
    let onSelect: (AccountRole) -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button {
                onSelect(.creator)
            } label: {
                Text("Creator")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(RoleButtonStyle(isPrimary: true))

            Button {
                onSelect(.brand)
            } label: {
                Text("Brand")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(RoleButtonStyle(isPrimary: false))
        }
    }
}

private struct RoleSegmentedControl: View {
    @Binding var selection: AccountRole

    var body: some View {
        HStack(spacing: 4) {
            ForEach(AccountRole.allCases) { role in
                Button {
                    selection = role
                } label: {
                    Text(role.rawValue)
                        .frame(maxWidth: .infinity)
                        .frame(height: 42)
                }
                .buttonStyle(RoleSegmentButtonStyle(isSelected: selection == role))
            }
        }
        .padding(4)
        .background {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.creatorButton)
                .overlay {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                }
        }
    }
}

private struct AccountTextField: View {
    let title: String
    let systemImage: String
    @Binding var text: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.creatorSecondaryText)
                .frame(width: 18)

            TextField(title, text: $text)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled()
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
                .tint(Color.creatorPrimary)
        }
        .accountFieldBackground()
    }
}

private struct AccountSecureField: View {
    let title: String
    let systemImage: String
    @Binding var text: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.creatorSecondaryText)
                .frame(width: 18)

            SecureField(title, text: $text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
                .tint(Color.creatorPrimary)
        }
        .accountFieldBackground()
    }
}

private struct DividerWithText: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        HStack(spacing: 10) {
            Rectangle()
                .fill(Color.white.opacity(0.08))
                .frame(height: 1)

            Text(text)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Color.creatorMuted)
                .fixedSize()

            Rectangle()
                .fill(Color.white.opacity(0.08))
                .frame(height: 1)
        }
    }
}

private struct SocialSignInButton: View {
    let title: String
    var leadingText: String?

    var body: some View {
        Button {
        } label: {
            HStack(spacing: 4) {
                if let leadingText {
                    Text(leadingText)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.white)
                }

                Text(title)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(SocialButtonStyle())
    }
}

private struct TermsText: View {
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Text("By signing up you agree to our")
                    .foregroundStyle(Color.creatorMuted)

                Button("Terms") {
                }
                .foregroundStyle(Color.creatorPrimary)

                Text("and")
                    .foregroundStyle(Color.creatorMuted)
            }

            Button("Privacy Policy") {
            }
            .foregroundStyle(Color.creatorPrimary)
        }
        .font(.system(size: 11, weight: .semibold))
    }
}

private struct RoleButtonStyle: ButtonStyle {
    let isPrimary: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .bold))
            .foregroundStyle(isPrimary ? .white : Color.creatorSecondaryText)
            .frame(height: 58)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(isPrimary ? Color.creatorPrimary : Color.creatorButton)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(isPrimary ? .clear : Color.white.opacity(0.08), lineWidth: 1)
                    }
            }
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.75), value: configuration.isPressed)
    }
}

private struct RoleSegmentButtonStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .bold))
            .foregroundStyle(isSelected ? .white : Color.creatorMuted)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(isSelected ? Color.creatorPrimary : .clear)
            }
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.75), value: configuration.isPressed)
    }
}

private struct PrimaryActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .bold))
            .foregroundStyle(.white)
            .frame(height: 54)
            .background {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.creatorPrimary)
            }
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.75), value: configuration.isPressed)
    }
}

private struct SocialButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 13, weight: .bold))
            .foregroundStyle(Color.creatorSecondaryText)
            .frame(height: 44)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.creatorButton)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    }
            }
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.75), value: configuration.isPressed)
    }
}

private struct CircleIconButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(Color.creatorSecondaryText)
            .background {
                Circle()
                    .fill(Color.creatorButton)
                    .overlay {
                        Circle()
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    }
            }
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.75), value: configuration.isPressed)
    }
}

private extension View {
    func accountFieldBackground() -> some View {
        frame(height: 52)
            .padding(.horizontal, 14)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.creatorInput)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.white.opacity(0.06), lineWidth: 1)
                    }
            }
    }
}

private extension Color {
    static let creatorBackground = Color(red: 0.06, green: 0.06, blue: 0.08)
    static let creatorPanel = Color(red: 0.08, green: 0.08, blue: 0.12)
    static let creatorCard = Color(red: 0.11, green: 0.11, blue: 0.16)
    static let creatorButton = Color(red: 0.10, green: 0.10, blue: 0.14)
    static let creatorInput = Color(red: 0.11, green: 0.11, blue: 0.15)
    static let creatorPrimary = Color(red: 0.34, green: 0.35, blue: 1.0)
    static let creatorMuted = Color(red: 0.28, green: 0.28, blue: 0.38)
    static let creatorSubtle = Color(red: 0.25, green: 0.25, blue: 0.34)
    static let creatorSecondaryText = Color(red: 0.70, green: 0.70, blue: 0.78)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            CreateAccountView(selectedRole: .constant(.creator)) {}
        }
    }
}
