//
//  InterestedCreatorsView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 08/08/2026.
//

import SwiftUI

struct InterestedCreatorsView: View {
    @ObservedObject var viewModel: GigInterestViewModel
    let gigID: UUID
    @State private var selectedCreator: CreatorProfile?
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.creatorBackground.ignoresSafeArea()
                sheetContent
                .navigationTitle("Interested Creators")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Close") { dismiss() }
                    }
                }
                .task {
                    await viewModel.loadInterestedCreators(gigID: gigID)
                }
            }
        }.sheet(item: $selectedCreator) { creator in
            CreatorDetailView(profile: creator)
        }
        
        
    }
    
    @ViewBuilder
    private var sheetContent: some View {
        if viewModel.isLoadingInterestedCreators {
            ProgressView("Loading Creators....")
        } else if let message = viewModel.interestedCreatorsError {
            ContentUnavailableView("Unable to load creators", systemImage: "exclamationmark.triangle",description: Text(message)) //from swift directly
        } else if viewModel.interestedCreators.isEmpty {
            ContentUnavailableView("No interested creators", systemImage: "person.2.slash", description: Text("No creators have indicated interest yet."))
        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.interestedCreators) { creator in
                        Button{
                            selectedCreator = creator
                        } label: {
                            DiscoverCreatorCard(profile: creator)
                        }.buttonStyle(.plain)
                     }
                }
                .padding()
            }
        }
    }
}
