//
//  NewShortView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 03/08/2026.
//

import SwiftUI

struct NewShortView: View {
    let videoURL: URL
    @ObservedObject var viewModel: CreatorShortsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var description: String = ""

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Describe your work !").font(.headline)
                TextEditor(text: $description)
                    .frame(height: 120)
                    .padding(8)
                    .background(Color.creatorInput)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                if let message = viewModel.message {
                    Text(message).font(.caption).foregroundStyle(.red)
                }

                Spacer()

                Button {
                    Task {
                        await viewModel.uploadShort(from: videoURL, description: description)
                        if viewModel.message == nil { dismiss() }
                    }
                } label: {
                    Text(viewModel.isLoading ? "Uploading..." : "Upload")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryActionButtonStyle())
                .disabled(viewModel.isLoading)
            }
            .padding(24)
            .background(Color.creatorBackground.ignoresSafeArea())
            .foregroundStyle(.white)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
