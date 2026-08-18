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
    
    func loadChannels(){
        guard let controller = service.makeChannelListController() else {return}
        channelListController = controller
        controller.channelsChangesPublisher
            .receive(on: DispatchQueue.main)
            .sink{[weak self] _ in
                self?.channels = Array(controller.channels)}
            .store(in: &cancellables)
        controller.synchronize()
    }
    func makeChannelController(for channel: ChatChannel) -> ChatChannelController? {
        service.makeChannelController(for: channel.cid)
    }
}
