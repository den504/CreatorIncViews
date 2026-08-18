//
//  BrandMainTabView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 26/07/2026.
//

import SwiftUI

struct BrandMainTabView: View {
    let onProfileTapped: () -> Void
    let onSignOut: () -> Void
    
    var body: some View {
        TabView {
            BrandHomeView(onProfileTapped: onProfileTapped, onSignOut: onSignOut).tabItem { Label("Home", systemImage: "house") }
            DiscoverView(role: .brand).tabItem{Label("Discover", systemImage: "magnifyingglass")}
            MyGigsView().tabItem { Label("My Gigs", systemImage: "briefcase") }
            ChatListView().tabItem {Label("Messages", systemImage: "message")}
        }
    }
}


