//
//  BrandMainTabView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 26/07/2026.
//

import SwiftUI

struct BrandMainTabView: View {
    let onProfileTapped: () -> Void
    
    var body: some View {
        TabView {
            BrandHomeView(onProfileTapped: onProfileTapped).tabItem { Label("Home", systemImage: "house") }
            DiscoverView().tabItem{Label("Discover", systemImage: "magnifyingglass")}
            MyGigsView().tabItem { Label("My Gigs", systemImage: "briefcase") }
            Text("Hello World — Messages").tabItem { Label("Messages", systemImage: "message") }
        }
    }
}


