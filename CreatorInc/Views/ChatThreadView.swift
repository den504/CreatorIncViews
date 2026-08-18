//
//  ChatThreadView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 18/08/2026.
//

import SwiftUI
import StreamChat

struct ChatThreadView: View { // view of individual chat
    @StateObject private var viewModel: ChatThreadViewModel
    @State private var draftText = ""
    @Environment(\.dismiss) private var dismiss
    
    
    init (controller: ChatChannelController) {
        _viewModel = StateObject(wrappedValue: ChatThreadViewModel(controller: controller))
    }
    
    var body : some View {
        NavigationStack{
            ZStack {
                Color.creatorBackground.ignoresSafeArea()
                VStack(spacing: 0){
                    messageList
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .padding(.horizontal)
                    }
                    composer
                }
            }
            .navigationTitle("Conversation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing){
                    Button("Close") {dismiss()}
                }
            }
        }
        .task{await viewModel.loadMessages()}
        
    }
    
    @ViewBuilder
    private var messageList: some View {
        ScrollView{
            LazyVStack(alignment: .leading, spacing: 8){
                ForEach(viewModel.messages) { message in
                    MessageBubble(message: message)
                }
            }.padding()
        }
    }
    
    private var composer: some View {
        HStack(spacing: 12){
            TextField("Message", text: $draftText)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    Task{await sendDraft()}
                }
            Button {
                Task {await sendDraft()}
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title)
            }.disabled(draftText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !viewModel.isReady)
        }.padding()
    }

    
    private func sendDraft() async {
        guard viewModel.isReady else {
            viewModel.errorMessage = "Still connecting, Please wait a second"
            return
        }
        let text = draftText
        draftText = ""
        do {
            try await viewModel.sendMessage(text: text)
        }catch{
            viewModel.errorMessage = error.localizedDescription
        }
        
    }
    
}

private struct MessageBubble: View {
    let message: ChatMessage
    var body: some View {
        HStack {
            if message.isSentByCurrentUser {Spacer()}
            Text(message.text)
                .padding(10)
                .background(message.isSentByCurrentUser ? Color.creatorPrimary: Color.creatorCard)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            if !message.isSentByCurrentUser{Spacer()}
        }
    }
}
