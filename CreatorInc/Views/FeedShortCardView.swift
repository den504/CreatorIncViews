import SwiftUI
import AVKit

struct FeedShortCardView: View {
    let short: FeedShort
    @State private var player: AVPlayer?


    var body: some View {

        VStack(alignment: .leading, spacing: 8) {
            creatorHeader
            descriptionText
            videoArea
            actionRow
        }
        .padding()
        .background(Color.creatorCard)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .foregroundStyle(.white)
    }
    


    private var thumbnail : some View {
        ZStack {
            AsyncImage(url: short.thumbnailURL) { image in
                image.resizable()
                    .scaledToFill()
            } placeholder: {
                Color.creatorCard
            }
            playBadge
        }
        .frame(height: 300)
        .clipShape(RoundedRectangle(cornerRadius: 10))  
    }
    private  var playBadge: some View {
        Image(systemName: "play.circle.fill")
            .font(.largeTitle)
            .foregroundColor(Color.creatorPrimary)
    }

    private var creatorPhoto: some View{
        AsyncImage(url: URL(string: short.profilePhotoURL ?? "")) { image in
            image.resizable()
        } placeholder: {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
        }
        .frame(width: 32, height: 32)
        .clipShape(Circle())
    }

    private  var creatorHeader: some View {
        HStack(spacing: 8) {
            creatorPhoto
            Text(short.displayName).font(.subheadline.bold())
            Spacer()
            Text(short.niche ?? "Creator")
                .font(.caption)
                .foregroundStyle(Color.creatorSecondaryText)

        }
    }

    @ViewBuilder
    private var descriptionText: some View {
        if let description = short.description, !description.isEmpty {
            Text(description)
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func startPlayback(){
        let newPlayer = AVPlayer(url: short.videoURL)
        newPlayer.play()
        player = newPlayer
    }
    
    @ViewBuilder
    private var videoArea: some View {
        if let player = player {
            VideoPlayer(player: player)
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        } else {
            thumbnail
                .onTapGesture (perform: startPlayback)
        }                                                                                                                                                
    }

    private var actionRow: some View {
        HStack(spacing: 24) {
            actionButtons(icon: "heart", label: "Like")
            actionButtons(icon: "bubble.right", label: "Comment")
            actionButtons(icon: "arrowshape.turn.up.right", label: "Share")
            Spacer()
        }
    }


    private func actionButtons(icon: String, label: String) -> some View {
        Button {
        } label: {
            Label(label, systemImage: icon).labelStyle(.iconOnly)
      
        } 
        .font(.title3)
        .foregroundStyle(Color.creatorMuted)
        .disabled(true)
        .accessibilityLabel("\(label), button is disabled")

    }
}

