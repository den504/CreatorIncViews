//
//  DiscoverView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 04/08/2026.
//

import SwiftUI

struct DiscoverView: View {
    @StateObject private var viewModel: DiscoverViewModel
    @State private var selectedCreator: CreatorProfile?
    @State private var selectedGig: Gig?
    let role: AccountRole

    init(role: AccountRole) {
        let service: DiscoverServicing
        self.role = role

        if let config = SupabaseConfig.config {
            service = SupabaseDiscoverService(config: config)
        } else {
            service = UnavailableDiscoverService()
        }

        _viewModel = StateObject(
            wrappedValue: DiscoverViewModel(
                service: service
            )
        )
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                sectionPicker // segement gigs and creators on the UI

                if let message = viewModel.message {
                    errorMessage(message)
                }

                discoverContent // selects which list to view
            }
            .background(
                Color.creatorBackground.ignoresSafeArea()
            )
            .navigationTitle("Discover")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "square.grid.2x2")
                        .foregroundStyle(
                            Color.creatorSecondaryText
                        )
                }
            }
        }
        .task {
            await viewModel.load() //preloads creator and gigs
        }
        .sheet(item: $selectedCreator) { creator in
            CreatorDetailView(profile: creator)
        }
        .sheet(item: $selectedGig) { gig in
            GigDetailView(gig: gig, context: gigDetailContext)
        }
    }

    private var sectionPicker: some View {
        Picker(// segement gigs and creators on the UI
            "Discover category",
            selection: $viewModel.selectedSection
        ) {
            ForEach(DiscoverSection.allCases) { section in
                Text(section.rawValue)
                    .tag(section)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }

    private func errorMessage( _ message: String) -> some View {
        Text(message)
            .font(.caption)
            .foregroundStyle(.red)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding(.horizontal)
    }

    @ViewBuilder
    private var discoverContent: some View {// selects which list to view
        switch viewModel.selectedSection {
        case .creators:
            creatorList

        case .gigs:
            gigList
        }
    }

    private var creatorList: some View { //call viewModel to get preloaded creators and call DiscoverCreatorCard to display reuseable cards
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach( viewModel.creators, id: \.id) { creator in
                    Button {
                        selectedCreator = creator
                    } label: {
                        DiscoverCreatorCard( profile: creator)
                    }
                    .buttonStyle(.plain)
                    .onAppear {
                        Task {
                            await viewModel.loadMoreIfNeeded(after: creator)
                        }
                    }
                }.accessibilityHint("Opens creator details")

                if viewModel.isLoadingCreators {
                    ProgressView()
                        .padding()
                }

                if !viewModel.isLoadingCreators,
                   viewModel.creators.isEmpty {
                    ContentUnavailableView(
                        "No creators available",
                        systemImage: "person.2"
                    )
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }

    private var gigList: some View {//call viewModel to get preloaded gigs and call DiscoverCreatorGigs to display reuseable cards
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.gigs) { gig in
                    Button {
                        selectedGig = gig
                    } label: {
                        DiscoverGigCard(gig: gig)
                    }
                    .buttonStyle(.plain)
                    .accessibilityHint("Opens gig details")
                }

                if viewModel.isLoadingGigs {
                    ProgressView()
                        .padding()
                }

                if !viewModel.isLoadingGigs,
                   viewModel.gigs.isEmpty {
                    ContentUnavailableView(
                        "No open gigs",
                        systemImage: "briefcase"
                    )
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
    
    
    private var gigDetailContext: GigDetailContext {
        switch role {
        case .creator: .discover
        case .brand: .brandDiscover
        }
    }
}


struct DiscoverCreatorCard: View {//reuseable creator card
    let profile: CreatorProfile

    private var photoURL: URL? {
        guard let address = profile.profilePhotoURL else {
            return nil
        }

        return URL(string: address)
    }

    var body: some View {
        HStack(spacing: 12) {
            creatorPhoto

            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                Text(profile.displayName)
                    .font(.headline)
                    .foregroundStyle(.white)

                Text(profile.niche ?? "Creator")
                    .font(.caption)
                    .foregroundStyle(
                        Color.creatorSecondaryText
                    )
                if let bio = profile.bio, !bio.isEmpty {
                    Text(bio)
                        .font(.caption)
                        .foregroundStyle(Color.creatorMuted)
                        .lineLimit(2)
                }
            }

            Spacer()
        }
        .padding(12)
        .background(Color.creatorCard)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 14,
                style: .continuous
            )
        )
    }

  
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
        .frame(width: 52, height: 52)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 14,
                style: .continuous
            )
        )
        .accessibilityHidden(true)
    }
}

struct DiscoverGigCard: View {//reuseable gig card
    let gig: Gig

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 10
        ) {
            gigHeader
            gigDescription
            gigTags
            gigFooter
        }
        .padding(14)
        .foregroundStyle(.white)
        .background(Color.creatorCard)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 14,
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: 14,
                style: .continuous
            )
            .stroke(
                Color.white.opacity(0.08),
                lineWidth: 1
            )
        }
    }

    private var gigHeader: some View {
        HStack(alignment: .top) {
            VStack(
                alignment: .leading,
                spacing: 3
            ) {
                Text(gig.title)
                    .font(.headline)

                Text(gig.companyName ?? "Brand")
                    .font(.caption)
                    .foregroundStyle(
                        Color.creatorSecondaryText
                    )
            }

            Spacer()

            Text("Open")
                .font(.caption.bold())
                .foregroundStyle(.green)
                .padding(.horizontal, 9)
                .padding(.vertical, 5)
                .background(
                    .green.opacity(0.15),
                    in: Capsule()
                )
        }
    }

    private var gigDescription: some View {
        Text(gig.brief)
            .font(.subheadline)
            .foregroundStyle(
                Color.creatorSecondaryText
            )
            .lineLimit(2)
    }

    @ViewBuilder
    private var gigTags: some View {
        if !gig.tags.isEmpty {
            Text(
                gig.tags.joined(
                    separator: " • "
                )
            )
            .font(.caption)
            .foregroundStyle(Color.creatorMuted)
            .lineLimit(1)
        }
    }

    private var gigFooter: some View {
        HStack {
            VStack(
                alignment: .leading,
                spacing: 2
            ) {
                Text(
                    gig.budget,
                    format: .currency(
                        code: "GBP"
                    )
                )
                .font(.headline)
                .foregroundStyle(
                    Color.creatorPrimary
                )

                Text(
                    "Closes \(formattedClosingDate)"
                )
                .font(.caption2)
                .foregroundStyle(
                    Color.creatorMuted
                )
            }

            Spacer()
        }
    }

    private var formattedClosingDate: String {
        gig.closesAt.formatted(
            date: .abbreviated,
            time: .omitted
        )
    }
}
