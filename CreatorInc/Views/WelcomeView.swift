//
//  WelcomeView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 16/06/2026.
//

import SwiftUI

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

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView { _ in }
    }
}
