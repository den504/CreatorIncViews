//
//  ContentView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 16/06/2026.
//

import SwiftUI

//
//  ContentView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 16/06/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        WelcomeView()
    }
}

struct WelcomeView: View {
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

                RoleSelectionButtons()

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
    var body: some View {
        HStack(spacing: 12) {
            Button {
            } label: {
                Text("Creator")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(RoleButtonStyle(isPrimary: true))

            Button {
            } label: {
                Text("Brand")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(RoleButtonStyle(isPrimary: false))
        }
    }
}

private struct RoleButtonStyle: ButtonStyle {
    let isPrimary: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .bold))
            .foregroundStyle(isPrimary ? .white : .creatorSecondaryText)
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

private extension Color {
    static let creatorBackground = Color(red: 0.06, green: 0.06, blue: 0.08)
    static let creatorPanel = Color(red: 0.08, green: 0.08, blue: 0.12)
    static let creatorCard = Color(red: 0.11, green: 0.11, blue: 0.16)
    static let creatorButton = Color(red: 0.10, green: 0.10, blue: 0.14)
    static let creatorPrimary = Color(red: 0.34, green: 0.35, blue: 1.0)
    static let creatorMuted = Color(red: 0.28, green: 0.28, blue: 0.38)
    static let creatorSubtle = Color(red: 0.25, green: 0.25, blue: 0.34)
    static let creatorSecondaryText = Color(red: 0.70, green: 0.70, blue: 0.78)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}