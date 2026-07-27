//
//  MyGigsView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 26/07/2026.
//

import SwiftUI

struct MyGigsView: View {
    @State private var gigs: [Gig] = []
    @State private var isShowingNewGig = false
    private let gigService: GigServicing
    @State private var loadError: String?
    @State private var selectedGig: Gig?


    
    init() {
        if let config = SupabaseConfig.config {
            gigService = SupabaseGigService(config: config)
        } else {
            gigService = UnavailableGigService()
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.creatorBackground.ignoresSafeArea()
                List(gigs) { gig in
                    
                    Button {
                        selectedGig = gig
                    } label: { // entier vstack of text in the card becomes a button
                        VStack(alignment: .leading, spacing: 6) {
                            Text(gig.title)
                                .font(.headline)
                                .foregroundColor(.white)
                            Text(gig.brief)
                                .font(.footnote)
                                .foregroundStyle(.white.opacity(0.7))
                                .lineLimit(2)
                            HStack {
                                Text(gig.budget, format: .currency(code: "GBP"))
                                    .font(.subheadline.bold())
                                    .foregroundColor(.white)
                                Spacer()
                                Text(gig.status.rawValue.capitalized)
                                    .font(.caption.bold())
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.blue, in: Capsule())
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .task { await loadGigs() }
                .navigationTitle("My Gigs")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isShowingNewGig = true
                        } label: {
                            Label("New Gig", systemImage: "plus")
                            //click tells the button to open up the sheet
                        }
                    }
                }
                .preferredColorScheme(.dark)
                .sheet(isPresented: $isShowingNewGig) {//opens sheet only when $isShowingNewGig is set to true on ToolbarItem
                    NewGigView(onGigCreated:handleGigCreated )
                        .presentationDetents([.medium, .large])// @escaping on NewGigView allows for the form to open without an actual
                    //gig passed but after form is filled and saved the viewmodel watches for the properties
                    // which the form gives it and sends it to the DB
                }
                .sheet(item: $selectedGig){ gig in
                    GigDetailView(gig: gig)
                }
                if let loadError {
                    Text(loadError)
                        .foregroundStyle(.red)
                        .padding()
                }

            }
        }



    }

    
    private func loadGigs() async {
        do {
            gigs = try await gigService.fetchGigs()
        } catch {
            loadError = error.localizedDescription
        }
    }
    
    private func handleGigCreated(_ gig: Gig) {
        gigs.insert(gig, at: 0)
    }



}
