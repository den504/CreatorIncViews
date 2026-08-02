//
//  ShortPlayerView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 01/08/2026.
//
import SwiftUI
import AVKit

struct ShortPlayerView: View {
    let short: CreatorShort
    @Environment(\.dismiss) private var dismiss


    var body: some View {
        if let url = URL(string: short.videoURL) {
            VideoPlayer(player: AVPlayer(url: url))
        }
        Button(action: {dismiss()}){
            Image(systemName: "xmark")
                .frame(width: 30, height: 30)
        }
        .buttonStyle(CircleIconButtonStyle())
        .padding()
    }
}

