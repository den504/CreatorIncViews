//
//  CreatorMainTabVieew.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 19/07/2026.
//

import SwiftUI

struct CreatorMainTabView: View {
    let onLogin: () -> Void
    
    var body: some View {
        
        TabView { // [Consistency → native navigation → TabView]
            CreatorHomeView(onLogin: onLogin).tabItem { Label("Home", systemImage: "house") }
            Text("Hello World — Discover").tabItem { Label("Discover", systemImage: "magnifyingglass") }
            Text("Hello World — My Gigs").tabItem { Label("My Gigs", systemImage: "briefcase") }
            Text("Hello World — Messages").tabItem { Label("Messages", systemImage: "message") }
        }
    }
}

private struct CreatorHomeView: View {
    let onLogin: () -> Void
    var body: some View {
        VStack(spacing: 20) {
            Text("Hello World")
            Button("Login", action: onLogin)
        }
    }
}
