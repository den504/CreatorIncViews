//
//  ChatListView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 18/08/2026.
//

import SwiftUI
import StreamChat


struct ChatListView: View { //List of chats 
    @StateObject private var viewModel: ChatViewModel
    @State private var selectedChannel: ChatChannel?
    
    init(){
        let service: ChatServicing
        if let supabaseConfig = SupabaseConfig.config, let streamConfig = StreamConfig.config {
            service = StreamChatService(supabaseConfig: supabaseConfig, streamConfig: streamConfig)
        } else {
            service = UnavailableChatService()
        }
        _viewModel = StateObject(wrappedValue: ChatViewModel(service: service))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.creatorBackground.ignoresSafeArea()
                content
            }
            .navigationTitle("Messages")
        }
        .task{viewModel.loadChannels()}
        .sheet(item: $selectedChannel){channel in
            if let controller = viewModel.makeChannelController(for: channel){
                ChatThreadView(controller: controller)
            }
            
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.channels.isEmpty {
            ContentUnavailableView(
                "No conversation yet",
                systemImage: "message",
                description: Text("Start a conversation from creators profile")
            )
        } else {
            ScrollView {
                LazyVStack(spacing: 12){
                    ForEach(viewModel.channels, id: \.cid) { channel in
                        Button {
                            selectedChannel = channel
                        } label:{
                            ChatChannelRow(channel: channel)
                        }
                        .buttonStyle(.plain)
                        
                        
                    }
                }
                .padding()
            }
        }
    }
    
}


private struct ChatChannelRow: View {
    let channel: ChatChannel
    var body: some View {
        VStack(alignment: .leading, spacing: 4){
            Text(displayName)
                .font(.headline)
                .foregroundStyle(.white)
            Text(channel.latestMessages.first?.text ?? "No messages yet")
                .font(.caption)
                .foregroundStyle(Color.creatorSecondaryText)
                .lineLimit(1)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.creatorCard)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private var displayName: String {
        if let name = channel.name, !name.isEmpty {return name}
        let currentUserId = channel.membership?.id
        let otherMember = channel.lastActiveMembers.first{$0.id != currentUserId}
        return otherMember?.name ?? "Conversation"
    }
}



