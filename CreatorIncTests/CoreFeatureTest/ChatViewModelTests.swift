import Foundation
import StreamChat
import Testing
@testable import CreatorInc

@MainActor
struct ChatViewModelTests {
    @Test("Loads chats")
    func loadChats(){
        let service = ChatServiceSpy()
        let viewModel = ChatViewModel(service: service)
        viewModel.loadChannels()

        #expect(service.channelListCallCount == 1)
    }

}


final class ChatServiceSpy: ChatServicing {
    private(set) var channelListCallCount = 0
    func connectUser(id: UUID, name: String, imageURL: URL?) async throws{}
    func disconnectUser() async {}
    func makeChannelListController() -> ChatChannelListController?{
        channelListCallCount += 1; return nil
    }
    func makeDirectChannelController(otherUserId: String) throws -> ChatChannelController{ throw NSError(domain: "Spy", code: 1)}
    func makeChannelController(for cid: ChannelId) -> ChatChannelController? {nil}
}