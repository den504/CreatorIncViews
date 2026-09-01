//
//  CreatordetailView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 04/08/2026.
//

import SwiftUI
import StreamChat


// view(aka sheet) which is visible from discover tab
// [Depth → sheet → read-only public creator details]
struct CreatorDetailView: View {
    let profile: CreatorProfile
    @Environment(\.dismiss) private var dismiss
    @State private var channelController: ChatChannelController?
    @State private var messagingError: String?
    @State private var isShowingThread = false
    @StateObject private var shortsViewModel = CreatorShortsStripViewModel(service: makeFeedService())
    @State private var selectedShort: CreatorShort?
    private let columns = [GridItem(.flexible()) , GridItem(.flexible())]

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
                            openConversation()
                        } label: {
                            Label("Message creator", systemImage: "message.fill")
                                .labelStyle(.iconOnly)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.circle)
                    .controlSize(.large)

                    creatorIdentity

                    creatorBio


                    shortsSection
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
        }.sheet(isPresented: $isShowingThread){
            if let channelController {
                ChatThreadView(controller: channelController)
            }
        }.task {
            await shortsViewModel.load(for: profile.userId)
        }.sheet(item: $selectedShort) { short in
            ShortPlayerView(short: short)
        }
    }
    
    private func openConversation() {
        messagingError = nil
        guard let supabaseConfig = SupabaseConfig.config, let streamConfig = StreamConfig.config else {
            messagingError = "Chat is unavailable"
            return
        }
        let service = StreamChatService(supabaseConfig: supabaseConfig, streamConfig: streamConfig)
        do {
            channelController = try service.makeDirectChannelController(otherUserId: profile.userId.uuidString.lowercased())
            isShowingThread = true
        }catch{
            messagingError = error.localizedDescription
        }
    }


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

    private func shortButton(for short: CreatorShort) -> some View {
        Button {
            selectedShort = short
        } label: {
            ShortThumbnailView(url: short.thumbnailURL)
        }
    }

    @ViewBuilder
    private var shortsSection: some View {
        if !shortsViewModel.shorts.isEmpty {
            Text("Shorts")
                .font(.title3.bold())
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(shortsViewModel.shorts, content: shortButton(for:))
            }
        }
    }
}
