//
//  GigDetailView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 26/07/2026.
//

import SwiftUI


nonisolated enum GigDetailContext {
    case discover
    case brandOwner
    case creatorSaved
    case brandDiscover
}

struct GigDetailView: View {
    let gig: Gig
    let context: GigDetailContext
    @StateObject private var interestViewModel: GigInterestViewModel
    @State private var isShowingInterestedCreators = false
    
    @Environment(\.dismiss) private var dismiss
    
    init (gig: Gig, context: GigDetailContext) {
        self.gig = gig
        self.context = context
        let service: GigInterestServicing
        if let config = SupabaseConfig.config
        {   service = SupabaseGigInterestService(config: config)
        } else {
            service = UnavailableGigInterestService()
        }
        _interestViewModel = StateObject(wrappedValue: GigInterestViewModel(service: service))
    }
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color.creatorBackground.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(gig.title)
                                .font(.largeTitle.bold())
                            Text(gig.budget, format: .currency(code: "GBP"))
                                .font(.title3)
                            Text(gig.status.rawValue.capitalized)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Brief")
                                .font(.title3.bold())
                            Text(gig.brief)
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Requirements")
                                .font(.title3.bold())
                            ForEach(gig.requirements, id: \.self) { requirement in
                                Text("\(requirement)")
                            }
                        }
                        if context == .brandOwner {
                            interestedCreatorsCard
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Deliverables")
                                .font(.title3.bold())
                            ForEach(gig.deliverables, id: \.self) { deliverable in
                                Text(" \(deliverable)")
                            }
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            if !gig.tags.isEmpty {
                                Text("Tags: \(gig.tags.joined(separator: ", "))")
                            }
                            Text("Closes on \(gig.closesAt.formatted(date: .abbreviated, time: .omitted))")
                        }
                        interestSection
                    }
                    .padding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
            .task {
                switch context {
                case .discover:
                    await interestViewModel.loadInterestState(gigID: gig.id)
                case .brandOwner:
                    await interestViewModel.loadInterestCount(gigID: gig.id)
                case .creatorSaved, .brandDiscover:
                    break
                }
            }
        }
        .sheet(isPresented: $isShowingInterestedCreators){
            InterestedCreatorsView(
                viewModel: interestViewModel,
                gigID: gig.id
            )
        }
    }
    
    @ViewBuilder
    private var interestSection: some View {
        if context == .discover {
            VStack(spacing: 12) {
                interestButton
                interestFeedback
            }
          
        }
    }
    
    private var interestedCreatorsCard: some View {
        Button {
            isShowingInterestedCreators = true //changes to true once tapped and ensures sheet opens
        } label : {
            VStack(alignment: .leading, spacing: 4) {
                Label("Interested Creators", systemImage: "person.2.fill").font(.headline)
                Text("Review creators who expressed interest in this gig.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                interestedCountLabel
                    .font(.headline)
                    .foregroundStyle(Color.creatorPrimary)
                    .tint(Color.creatorPrimary)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.creatorCard)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            }
        }.buttonStyle(.plain)


    }
    
    @ViewBuilder
    private var interestedCountLabel: some View {
        if let count = interestViewModel.interestCount {
            Text("\(count) Interested" ) //once you do an optional when you call the property you have to take care of what happens if it doesn't show up
        } else if interestViewModel.errorMessage != nil {
            Text("Count unavailable")
        } else {
            ProgressView().controlSize(.small)
        }
        
    }
    
    private var interestButton: some View {
        Button {
            Task { await interestViewModel.indicateInterest(gigID: gig.id)
            }
        } label: {
            Text(interestViewModel.isLoading ? "Please wait..." : "Indicate interest").frame(maxWidth: .infinity)
        }.buttonStyle(PrimaryActionButtonStyle())
            .disabled(interestViewModel.isLoading || interestViewModel.hasIndicatedInterest)
    }
    
    @ViewBuilder
    private var interestFeedback: some View {
        if let message = interestViewModel.successMessage { Text(message).font(.caption).foregroundStyle(.green) }
        if let message = interestViewModel.errorMessage { Text(message).font(.caption).foregroundStyle(.red) }
    }
    
    
}
