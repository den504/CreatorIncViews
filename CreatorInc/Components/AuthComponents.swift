//
//  AuthComponents.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 16/06/2026.
//

import SwiftUI

struct RoleSegmentedControl: View {
    @Binding var selection: AccountRole

    var body: some View {
        HStack(spacing: 4) {
            ForEach(AccountRole.allCases) { role in
                Button {
                    selection = role
                } label: {
                    Text(role.title)
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

struct AccountTextField: View {
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

struct AccountSecureField: View {
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

struct DividerWithText: View {
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

struct SocialSignInButton: View {
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

struct TermsText: View {
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

struct RoleButtonStyle: ButtonStyle {
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

struct RoleSegmentButtonStyle: ButtonStyle {
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

struct PrimaryActionButtonStyle: ButtonStyle {
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

struct SocialButtonStyle: ButtonStyle {
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

struct CircleIconButtonStyle: ButtonStyle {
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

extension View {
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
