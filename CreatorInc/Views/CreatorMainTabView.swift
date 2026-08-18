//
//  CreatorMainTabVieew.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 19/07/2026.
//

import SwiftUI

struct CreatorMainTabView: View {
    let onProfileTapped: () -> Void
    let onSignOut: () -> Void
    
    var body: some View {
        
        TabView {
            CreatorHomeView(onProfileTapped: onProfileTapped, onSignOut: onSignOut).tabItem { Label("Home", systemImage: "house") }
            DiscoverView(role: .creator).tabItem {Label("Discover", systemImage: "magnifyingglass")}
            CreatorMyGigsView().tabItem { Label("My Gigs", systemImage: "briefcase") }
            ChatListView().tabItem {Label("Messages", systemImage: "message")}
        }
    }
}

