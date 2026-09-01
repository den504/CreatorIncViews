//
//  CreatorProfileView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 18/07/2026.
//

import SwiftUI
import PhotosUI //enables PhotoPicker

struct CreatorProfileView: View {
    @StateObject private var shortsViewModel: CreatorShortsViewModel
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedShort: CreatorShort?
    @State private var shortPendingDelete: CreatorShort?
    @State private var isShowingDeleteConfirmation = false
    @State private var pickedVideo: PickedVideoSheetItem?
    
    let profile: CreatorProfile
    let onEdit: () -> Void
    let onBack: () -> Void
    
    init(profile: CreatorProfile, onEdit: @escaping () -> Void, onBack: @escaping () -> Void) {
        self.profile = profile
        self.onEdit = onEdit
        self.onBack = onBack
        let service: VideoServicing
        
        if let config = SupabaseConfig.config {
            service = SupabaseVideoService(config: config)
        } else {
            service = UnavailableVideoService()
        }
        _shortsViewModel = StateObject(wrappedValue: CreatorShortsViewModel(videoService: service))
    }
    
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                if let urlText = profile.profilePhotoURL,
                   let url = URL(string: urlText) {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        ProgressView() //Loading Spinner built into SwiftUI
                    }
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                }
                Text(profile.displayName)
                if let bio = profile.bio, !bio.isEmpty {
                    Text(bio)
                        .font(.subheadline)
                        .foregroundStyle(Color.creatorSecondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
                if let niche = profile.niche{
                    Text(niche)
                }
                metricsSection
                shortsHeader
                shortsSection
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.creatorBackground.ignoresSafeArea())
        .foregroundStyle(.white)
    }
    
    private var header: some View {
        HStack {
            Button(action: onBack) { // Back Button
                Image(systemName: "chevron.left")
                    .frame(width: 30, height: 30)
            }
            .buttonStyle(CircleIconButtonStyle())
            Spacer()
            Button("Edit", action: onEdit)
                .font(.subheadline.bold())
        }
        .foregroundStyle(.white)
    }
    
    private func metricCard(value: String, label: String, color: Color) -> some View { //reuseable tiles for social media stats
        VStack(spacing: 4) {
            HStack(spacing: 5) {
                Circle().fill(color).frame(width: 6, height: 6)
                Text(value).font(.system(size: 18, weight: .bold))
            }
            Text(label).font(.system(size: 10)).foregroundStyle(Color.creatorMuted)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 12)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.creatorCard))
    }
    
    private var metricsSection: some View { // actual followership metriccard func included
        HStack(spacing: 8) {
            metricCard(value: "84K", label: "Instagram", color: .pink)
            metricCard(value: "31K", label: "TikTok", color: .cyan)
            metricCard(value: "6.2%", label: "Engagement", color: .purple)
        }
    }
    
    private var shortsHeader: some View {
        HStack {
            Text("Shorts").font(.headline)
            Spacer()
            PhotosPicker(selection: $selectedItem, matching: .videos) {
                Image(systemName: "plus.circle.fill")
                    .foregroundStyle(Color.creatorPrimary)
            }
            Text("Upload")
                .font(.caption.bold())
                .foregroundStyle(Color.creatorPrimary)
        }
        .onChange(of: selectedItem) { _, newItem in //moves video from IOS disk to apps using LoadTansferable in utilities
            guard let newItem else { return }
            Task {
                do {
                    guard let video = try await newItem.loadTransferable(type: PickedVideo.self) else { return }
//                    await shortsViewModel.uploadShort(from: video.url)
                    pickedVideo = PickedVideoSheetItem(url: video.url)
                } catch {
                    shortsViewModel.message = error.localizedDescription
                }
            }
        }
    }

    
    // private func shortThumbnail(url: String) -> some View { //Thumb nails for shorts, gets the url from short card
    //     ZStack {
    //         AsyncImage(url: URL(string: url)) { image in
    //             image.resizable().scaledToFill()
    //         } placeholder: {
    //             Color.creatorCard
    //         }
    //         Image(systemName: "play.fill")
    //             .font(.caption.bold()).padding(12)
    //             .background(Color.creatorPrimary)
    //             .clipShape(Circle())
    //     }
    //     .frame(height: 110)
    //     .clipShape(RoundedRectangle(cornerRadius: 10))
    // }
    
    private func shortCard(short: CreatorShort) -> some View {
        Button {
            selectedShort = short
        } label : {
            VStack(alignment: .leading, spacing: 7) {
                // shortThumbnail(url: short.thumbnailURL)
                ShortThumbnailView(url: short.thumbnailURL)
                Text(short.createdAt.formatted(.relative(presentation: .named)))
                    .font(.caption).foregroundStyle(Color.creatorMuted)
            }
            .frame(maxWidth: .infinity, alignment: .leading).padding(8)
            .background(Color.creatorCard).clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .contextMenu{ //confirms deletion is about to happen
            Button(role: .destructive){
                shortPendingDelete = short
                isShowingDeleteConfirmation  = true
            }label:{
                Label("Delete", systemImage: "trash")
            }
        }
    }
    private var shortsSection: some View {
        Group {
            if shortsViewModel.isLoading && shortsViewModel.shorts.isEmpty {
                ProgressView()
            } else if shortsViewModel.shorts.isEmpty {
                Text("No shorts yet — add your first video")
                    .font(.caption)
                    .foregroundStyle(Color.creatorMuted)
            } else {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(shortsViewModel.shorts) { short in
                        shortCard(short: short)
                    }
                }
            }
            if let message = shortsViewModel.message {
                Text(message).font(.caption).foregroundStyle(.red)
            }
        }
        .task { await shortsViewModel.loadShorts() }
        .sheet(item: $selectedShort) { short in
            ShortPlayerView(short: short)
        }
        .sheet(item: $pickedVideo) { item in
            NewShortView(videoURL: item.url, viewModel: shortsViewModel)
            }
        .confirmationDialog("Delete this short?", isPresented: $isShowingDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                if let shortPendingDelete {
                    Task { await shortsViewModel.deleteShort(shortPendingDelete) }
                }
            }
        }
    }
}

private struct PickedVideoSheetItem: Identifiable {
    let id = UUID()
    let url: URL
}

