//
//  BrandProfileView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 18/07/2026.
//

import SwiftUI

struct BrandProfileView: View {
    let profile: BrandProfile
    let onEdit: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        
        ScrollView{
            
            VStack(alignment: .leading, spacing: 28) {
                Button(action: onBack) { 
                    Image(systemName: "chevron.left")
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(CircleIconButtonStyle())
                Text(profile.companyName)
                    .font(.title.bold())
                if let intro = profile.brandIntro {
                    Text(intro)
                }
                if let industries = profile.industries, !industries.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Industries").font(.title3.bold())
                        ReadOnlyChipGridView(values: industries)
                    }
                }
                if let website = profile.website,
                   let websiteURL = makeWebsiteURL(from: website) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Website").font(.title3.bold())
                        Link(website, destination: websiteURL)
                    }
                }
                if let location = profile.location {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Location").font(.title3.bold())
                        Text(location)
                    }
                }
                if let niches = profile.targetCreatorNiches, !niches.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Target creator niches").font(.title3.bold())
                        ReadOnlyChipGridView(values: niches)
                    }
                }
                Button("Edit", action: onEdit)
                
            }.padding()
        }
        .background(Color.creatorBackground.ignoresSafeArea())
        .foregroundStyle(.white)
    }
}

private func makeWebsiteURL(from website: String) -> URL? { // [SoC → pure function → URL conversion]
    let hasScheme = website.hasPrefix("http://") || website.hasPrefix("https://")
    let address = hasScheme ? website : "https://\(website)"
    return URL(string: address)
}
    
