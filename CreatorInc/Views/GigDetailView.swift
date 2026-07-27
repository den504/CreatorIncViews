//
//  GigDetailView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 26/07/2026.
//

import SwiftUI

struct GigDetailView: View {
    let gig: Gig
    @Environment(\.dismiss) private var dismiss
    
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
                                Text("• \(requirement)")
                            }
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Deliverables")
                                .font(.title3.bold())
                            ForEach(gig.deliverables, id: \.self) { deliverable in
                                Text("• \(deliverable)")
                            }
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            if !gig.tags.isEmpty {
                                Text("Tags: \(gig.tags.joined(separator: ", "))")
                            }
                            Text("Closes on \(gig.closesAt.formatted(date: .abbreviated, time: .omitted))")
                            Text("\(gig.interestedCount) interested")
                        }
                    }
                    .padding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }

        }
    }
}
