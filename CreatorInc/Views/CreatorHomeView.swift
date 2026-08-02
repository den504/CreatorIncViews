//
//  CreatorHomeView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 31/07/2026.
//

import SwiftUI

struct CreatorHomeView: View {
    let onLogin: () -> Void
    let onProfileTapped: () -> Void
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.creatorBackground.ignoresSafeArea()
                VStack(spacing: 20) {
                    Text("Hello World")
                    Button("Login", action: onLogin)
                }.toolbar {
                    ToolbarItem(placement: .topBarTrailing){
                        Button(action: onProfileTapped){
                            Image(systemName: "person.crop.circle")
                        }
                    }
                }
            }
        }
    }
}
