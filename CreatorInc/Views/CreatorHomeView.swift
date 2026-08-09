//
//  CreatorHomeView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 31/07/2026.
//

import SwiftUI

struct CreatorHomeView: View {
    let onProfileTapped: () -> Void
    let onSignOut: () -> Void
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.creatorBackground.ignoresSafeArea()
                VStack(spacing: 20) {
                    Text("Hello World")
                }.toolbar {
                    ToolbarItem(placement: .topBarTrailing){
                        Button(action: onProfileTapped){
                            Image(systemName: "person.crop.circle")
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: onSignOut) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                        }
                        .accessibilityLabel("Sign out")
                    }
                }
            }
        }
    }
}
