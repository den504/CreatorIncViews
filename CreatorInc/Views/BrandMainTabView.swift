//
//  BrandMainTabView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 26/07/2026.
//

import SwiftUI

struct BrandMainTabView: View {
    var body: some View {
        TabView {
            Text("Hello World — Home").tabItem { Label("Home", systemImage: "house") }
            Text("Hello World — Discover").tabItem { Label("Discover", systemImage: "magnifyingglass") }
            MyGigsView().tabItem { Label("My Gigs", systemImage: "briefcase") }
            Text("Hello World — Messages").tabItem { Label("Messages", systemImage: "message") }
        }
    }
}


