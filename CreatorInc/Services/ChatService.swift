//
//  ChatServicing.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 18/08/2026.
//

import Foundation
import Supabase
import StreamChat

protocol ChatServicing {
    func connectUser(id: UUID, name: String, imageURL: URL?) async throws
    func disconnectUser() async
    func makeChannelListController() -> ChatChannelListController?
    func makeDirectChannelController(otherUserId: String) throws -> ChatChannelController
    func makeChannelController(for cid: ChannelId) -> ChatChannelController?
}

struct StreamChatService: ChatServicing {
    private let supabaseClient: SupabaseClient
    private static var sharedChatClient: ChatClient?
    private let chatClient: ChatClient
    
    init(supabaseConfig: SupabaseConfig, streamConfig: StreamConfig){
        supabaseClient = SupabaseClient(supabaseURL: supabaseConfig.projectURL, supabaseKey: supabaseConfig.anonKey)
        if let existing = Self.sharedChatClient {
            chatClient = existing
        } else {
            let config = ChatClientConfig(apiKey: .init(streamConfig.apiKey))
            let client = ChatClient(config: config)
            Self.sharedChatClient = client
            chatClient = client
        }
        
    }
    //login
    func connectUser(id: UUID, name: String, imageURL: URL?) async throws {
        struct TokenResponse: Decodable {let token: String}
        let response: TokenResponse = try await supabaseClient.functions.invoke("stream-token")
        let token = try Token(rawValue: response.token)
        let userInfo = UserInfo(id: id.uuidString.lowercased(), name: name, imageURL: imageURL)
        try await chatClient.connectUser(userInfo: userInfo, token: token)
    }
    
    //log out
    func disconnectUser() async {
        await chatClient.disconnect()
    }
    
    //open chat list
    func makeChannelListController() -> ChatChannelListController? {
        guard let currentUserId = chatClient.currentUserId else {return nil}
        let query = ChannelListQuery(filter: .containMembers(userIds: [currentUserId]))
        return chatClient.channelListController(query: query)
    }
    
    //direct messaging
    func makeDirectChannelController(otherUserId: String) throws -> ChatChannelController {
        try chatClient.channelController(createDirectMessageChannelWith: [otherUserId], messageOrdering: .bottomToTop, extraData: [:])
    }
    //reconnects chat from list
    func makeChannelController(for cid: ChannelId) -> ChatChannelController? {
        chatClient.channelController(for: cid, messageOrdering: .bottomToTop)
    }


}

struct UnavailableChatService: ChatServicing {
    func connectUser(id: UUID, name: String, imageURL: URL?) async throws {
        throw AuthValidationError.missingSupabaseConfig
    }
    func disconnectUser() async {}
    func makeChannelListController() -> ChatChannelListController?{nil}
    func makeDirectChannelController(otherUserId: String) throws -> ChatChannelController {
        throw AuthValidationError.missingSupabaseConfig
    }
    func makeChannelController(for cid: ChannelId) -> ChatChannelController?{nil}
}
