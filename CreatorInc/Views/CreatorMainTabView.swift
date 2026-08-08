//
//  CreatorMainTabVieew.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 19/07/2026.
//

import SwiftUI

struct CreatorMainTabView: View {
    let onLogin: () -> Void
    let onProfileTapped: () -> Void
    
    var body: some View {
        
        TabView { // [Consistency → native navigation → TabView]
            CreatorHomeView(onLogin: onLogin, onProfileTapped: onProfileTapped).tabItem { Label("Home", systemImage: "house") }
            DiscoverView().tabItem {Label("Discover", systemImage: "magnifyingglass")}
            Text("Hello World — My Gigs").tabItem { Label("My Gigs", systemImage: "briefcase") }
            Text("Hello World — Messages").tabItem { Label("Messages", systemImage: "message") }
        }
    }
}

