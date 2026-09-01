import SwiftUI


struct ShortsFeedView: View {
    @StateObject private var viewModel: ShortsFeedViewModel
    

    init() {
        _viewModel = StateObject(wrappedValue: ShortsFeedViewModel(service: makeFeedService()))
    }

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.shorts, content: card(for:)) 
                feedStatusView
            }.padding(.horizontal)
        }
        .background(Color.creatorBackground)
        .task {await viewModel.load()}
    }



    private func card(for short: FeedShort) -> some View {
        FeedShortCardView(short: short)
        .onAppear {
            Task {
                await viewModel.loadMoreIfNeeded(after: short)
            }
        }

    }



    private var feedStatusView: some View {
        Group {
            if viewModel.isLoading {
                ProgressView().padding()
            } 
            if let message = viewModel.message {
                Text(message)
                    .foregroundColor(.red)
            } 
            if !viewModel.isLoading && viewModel.shorts.isEmpty {
                Text("No shorts available")
                    .foregroundColor(.gray)
            }
        }
    }
}

func makeFeedService() -> FeedServicing {
    guard let config = SupabaseConfig.config else {
        return UnavailableFeedService()
    }
    return SupabaseFeedService(config: config)
}


