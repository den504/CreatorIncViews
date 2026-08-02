//
//  BrandHomeView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 31/07/2026.
//

import SwiftUI

struct BrandHomeView: View {
    let onProfileTapped: () -> Void

    var body: some View {
        NavigationStack {

            ZStack{
                Color.creatorBackground.ignoresSafeArea()
                Text("Hello World — Home")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            
                            Button(action: onProfileTapped) {
                                Image(systemName: "person.crop.circle")
                            }
                            
                        }
                    }
            }
        }
    }
}

