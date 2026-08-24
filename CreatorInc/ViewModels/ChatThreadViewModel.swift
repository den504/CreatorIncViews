//
//  ChatThreadViewModel.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 18/08/2026.
//

import Combine
import Foundation
import StreamChat

@MainActor
final class ChatThreadViewModel: ObservableObject {
    @Published private(set) var messages: [ChatMessage] = []
    @Published private(set) var isReady = false
    @Published var errorMessage: String?
    
    private let controller: ChatChannelController
    private var cancellables = Set<AnyCancellable>()
    
    init(controller: ChatChannelController){
        self.controller = controller
    }
    
    func loadMessages() async {
        //watch or listen for messages to display e.g listener
        controller.messagesChangesPublisher
            .receive(on: DispatchQueue.main)
            .sink{[weak self] _ in
                //read message
                self?.messages = self?.controller.messages ?? []
            }
            .store(in: &cancellables)
        do{
            //wait for synchronize call back 
            try await withCheckedThrowingContinuation{(continuation: CheckedContinuation<Void, Error>) in
                //fetch messages and open connection for new messages
                controller.synchronize{error in
                    if let error {continuation.resume(throwing:error)} else {continuation.resume()}
                }
            }
            isReady = true
            
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
    }
    
    func sendMessage (text: String) async throws {
        try await withCheckedThrowingContinuation{(continuation: CheckedContinuation<Void, Error>) in
            //send messages
            controller.createNewMessage(text: text) {result in
                continuation.resume(with: result.map{_ in ()})
            }
            
        }
    }
}
