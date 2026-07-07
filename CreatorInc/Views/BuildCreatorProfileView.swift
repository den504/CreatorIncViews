//
//  BuildCreatorProfileView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 07/07/2026.
//

import SwiftUI

struct BuildCreatorProfileView: View {
    @State private var fullName = ""
    @State private var selectedCategory = "Travel"
    @State private var message: String?

    private let categories = ["Travel", "Lifestyle", "Beauty", "Tech", "Food"]

    var body: some View {
        ZStack {
            Color.creatorBackground.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                header
                    .padding(.bottom, 24)

                photoButton
                    .padding(.bottom, 22)

                profileFields
                    .padding(.bottom, 20)

                if let message {
                    Text(message)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.creatorSecondaryText)
                        .padding(.bottom, 12)
                }

                saveButton

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 34)
            .padding(.top, 28)
            .frame(maxWidth: 420, maxHeight: .infinity, alignment: .top)
        }
    }

    // [Clarity -> visual hierarchy -> screen title]
    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Build your profile")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("Add the basics creators will see first")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.creatorMuted)
        }
    }

    // [Feedback -> direct manipulation -> tappable photo placeholder]
    private var photoButton: some View {
        Button {
            message = "Photo upload will come next."
        } label: {
            VStack(spacing: 8) {
                Image(systemName: "camera.fill")
                    .font(.system(size: 22, weight: .bold))

                Text("Add photo")
                    .font(.system(size: 12, weight: .bold))
            }
            .foregroundStyle(Color.creatorSecondaryText)
            .frame(width: 92, height: 92)
        }
        .background {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.creatorButton)
                .overlay {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                }
        }
    }

    // [SoC -> SwiftUI composition -> grouped form fields]
    private var profileFields: some View {
        VStack(alignment: .leading, spacing: 14) {
            ProfileFieldLabel("Full name")

            AccountTextField(
                title: "Jess Miller",
                systemImage: "person.fill",
                text: $fullName
            )

            ProfileFieldLabel("Category")

            categoryGrid
        }
    }

    // [Clarity -> standard controls -> category chips]
    private var categoryGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 92), spacing: 10)], spacing: 10) {
            ForEach(categories, id: \.self) { category in
                Button {
                    selectedCategory = category
                } label: {
                    Text(category)
                        .frame(maxWidth: .infinity)
                        .frame(height: 38)
                }
                .buttonStyle(CategoryChipStyle(isSelected: selectedCategory == category))
            }
        }
    }

    // [Feedback -> status communication -> local flow confirmation]
    private var saveButton: some View {
        Button {
            message = fullName.isEmpty ? "Add your full name to continue." : "Profile form is ready to save."
        } label: {
            Text("Save & Continue")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(PrimaryActionButtonStyle())
    }
}

private struct ProfileFieldLabel: View {
    let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title.uppercased())
            .font(.system(size: 11, weight: .bold))
            .foregroundStyle(Color.creatorMuted)
    }
}

private struct CategoryChipStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 13, weight: .bold))
            .foregroundStyle(isSelected ? .white : Color.creatorSecondaryText)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(isSelected ? Color.creatorPrimary : Color.creatorButton)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.white.opacity(isSelected ? 0 : 0.08), lineWidth: 1)
                    }
            }
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.75), value: configuration.isPressed)
    }
}
