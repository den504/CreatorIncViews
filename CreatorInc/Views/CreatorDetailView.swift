//
//  CreatordetailView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 04/08/2026.
//

import SwiftUI


// view(aka sheet) which is visible from discover tab
// [Depth → sheet → read-only public creator details]
struct CreatorDetailView: View {
    let profile: CreatorProfile
    @Environment(\.dismiss) private var dismiss

    private var photoURL: URL? {
        guard let address = profile.profilePhotoURL else {
            return nil
        }

        return URL(string: address)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24){
                    HStack {
                        creatorPhoto
                        Spacer()
                        Button{
                            
                        } label: {
                            Label("Message creator", systemImage: "message.fill")
                                .labelStyle(.iconOnly)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.circle)
                    .controlSize(.large)
                    .disabled(true)
                    creatorIdentity

                    creatorBio
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .padding(24)
            }
            .background(
                Color.creatorBackground.ignoresSafeArea()
            )
            .foregroundStyle(.white)
            .navigationTitle("Creator")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(
                    placement: .topBarTrailing
                ) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }

    // [Clarity → visual hierarchy → prominent profile image]
    @ViewBuilder
    private var creatorPhoto: some View {
        AsyncImage(url: photoURL) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            Image(
                systemName: "person.crop.circle.fill"
            )
            .resizable()
            .foregroundStyle(
                Color.creatorSecondaryText
            )
        }
        .frame(width: 120, height: 120)
        .clipShape(Circle())
        .accessibilityHidden(true)
    }

    private var creatorIdentity: some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            Text(profile.displayName)
                .font(.largeTitle.bold())

            if let niche = profile.niche,
               !niche.isEmpty {
                Text(niche)
                    .font(.headline)
                    .foregroundStyle(
                        Color.creatorPrimary
                    )
            }
        }
    }

    @ViewBuilder
    private var creatorBio: some View {
        if let bio = profile.bio,
           !bio.isEmpty {
            VStack(
                alignment: .leading,
                spacing: 8
            ) {
                Text("About")
                    .font(.title3.bold())

                Text(bio)
                    .foregroundStyle(
                        Color.creatorSecondaryText
                    )
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )
            }
        }
    }
}
