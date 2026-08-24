//
//  ChatViewModel.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 18/08/2026.
//

import Combine
import Foundation
import StreamChat

@MainActor

final class ChatViewModel: ObservableObject { //view model for chat list
    @Published private(set) var channels: [ChatChannel] = []
    
    private let service: ChatServicing
    private var channelListController: ChatChannelListController?
    private var cancellables = Set<AnyCancellable>()
    
    init(service: ChatServicing){
        self.service = service
    }
    
    //https://getstream.io/chat/docs/sdk/ios/combine/channels/
    //uses method chaining
    func loadChannels(){
        guard let controller = service.makeChannelListController() else {return}
        channelListController = controller
        controller.channelsChangesPublisher
            .receive(on: DispatchQueue.main) //changes happen on the main 
            .sink{[weak self] _ in //only use list when view is being used
                self?.channels = Array(controller.channels)}
            .store(in: &cancellables)
        controller.synchronize()
    }
    //reconnects chat from list
    func makeChannelController(for channel: ChatChannel) -> ChatChannelController? {
        service.makeChannelController(for: channel.cid)
    }
}
