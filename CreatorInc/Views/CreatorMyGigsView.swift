//
//  CreatorMigGigView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 08/08/2026.
//

import SwiftUI

struct CreatorMyGigsView: View {
    @StateObject private var viewModel: CreatorMyGigsViewModel
    @State private var selectedGig: Gig?

    init() {
        let service: GigInterestServicing

        if let config = SupabaseConfig.config {
            service = SupabaseGigInterestService(config: config)
        } else {
            service = UnavailableGigInterestService()
        }

        _viewModel = StateObject(
            wrappedValue: CreatorMyGigsViewModel(service: service)
        )
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.creatorBackground.ignoresSafeArea()
                content
            }
            .navigationTitle("My Gigs")
        }
        .preferredColorScheme(.dark)
        .task {
            await viewModel.load()
        }
        .sheet(item: $selectedGig) { gig in
            GigDetailView(gig: gig, context: .creatorSaved)
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView("Loading gigs...")
        } else if let message = viewModel.errorMessage {
            ContentUnavailableView(
                "Unable to load gigs",
                systemImage: "exclamationmark.triangle",
                description: Text(message)
            )
        } else if viewModel.gigs.isEmpty {
            ContentUnavailableView(
                "No saved gigs",
                systemImage: "briefcase",
                description: Text(
                    "Gigs you indicate interest in will appear here."
                )
            )
        } else {
            gigList
        }
    }

    private var gigList: some View {
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
            }
            .padding()
        }
    }
}
