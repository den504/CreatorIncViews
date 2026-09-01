import SwiftUI

struct ShortThumbnailView: View {
    let url: String
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: url)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.creatorCard
            }
            Image(systemName: "play.fill")
                .font(.caption.bold()).padding(12)
                .background(Color.creatorPrimary)
                .clipShape(Circle())
        }
        .frame(height: 110)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

}