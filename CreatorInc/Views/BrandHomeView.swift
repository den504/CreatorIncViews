//
//  BrandHomeView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 31/07/2026.
//

import SwiftUI

struct BrandHomeView: View {
    let onProfileTapped: () -> Void
    let onSignOut: () -> Void

    var body: some View {
        NavigationStack {

            ZStack{
                Color.creatorBackground.ignoresSafeArea()
                ShortsFeedView()
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            
                            Button(action: onProfileTapped) {
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

