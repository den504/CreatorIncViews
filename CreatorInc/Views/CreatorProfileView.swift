//
//  CreatorProfileView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 18/07/2026.
//

import SwiftUI

struct CreatorProfileView: View {
    let profile: CreatorProfile
    let onEdit: () -> Void
    let onBack: () -> Void
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                if let urlText = profile.profilePhotoURL,
                   let url = URL(string: urlText) {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        ProgressView() //Loading Spinner built into SwiftUI
                    }
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                }
                Text(profile.displayName)
                if let bio = profile.bio, !bio.isEmpty { 
                    Text(bio)
                        .font(.subheadline)
                        .foregroundStyle(Color.creatorSecondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
                if let niche = profile.niche{
                    Text(niche)
                }
                metricsSection
                shortsHeader
                shortsSection
            }
        }
            .padding(24)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(Color.creatorBackground.ignoresSafeArea())
            .foregroundStyle(.white)
    }
    
    private var header: some View {
        HStack {
            Button(action: onBack) { // Back Button
                Image(systemName: "chevron.left")
                    .frame(width: 30, height: 30)
            }
            .buttonStyle(CircleIconButtonStyle())
            Spacer()
            Button("Edit", action: onEdit)
                .font(.subheadline.bold())
        }
        .foregroundStyle(.white)
    }
    
    private func metricCard(value: String, label: String, color: Color) -> some View { //reuseable tiles for social media stats
        VStack(spacing: 4) {
            HStack(spacing: 5) {
                Circle().fill(color).frame(width: 6, height: 6)
                Text(value).font(.system(size: 18, weight: .bold))
            }
            Text(label).font(.system(size: 10)).foregroundStyle(Color.creatorMuted)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 12)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.creatorCard))
    }
    
    private var metricsSection: some View { // actual followership metriccard func included
        HStack(spacing: 8) {
            metricCard(value: "84K", label: "Instagram", color: .pink)
            metricCard(value: "31K", label: "TikTok", color: .cyan)
            metricCard(value: "6.2%", label: "Engagement", color: .purple)
        }
    }
    
    private var shortsHeader: some View { //shorts
        HStack {
            Text("Shorts").font(.headline)
            Spacer()
            Text("See all")
                .font(.caption.bold())
                .foregroundStyle(Color.creatorPrimary)
        }
    }
    
    private func shortThumbnail(color: Color) -> some View { //Thumb nails for shorts
        ZStack {
            RoundedRectangle(cornerRadius: 10).fill(color)
            Image(systemName: "play.fill")
                .font(.caption.bold()).padding(12)
                .background(Color.creatorPrimary)
                .clipShape(Circle())
        }
        .frame(height: 110)
    }
    private func shortCard(title: String, views: String, age: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            shortThumbnail(color: color) //play button thumbnail
            Text(views).font(.caption2.bold()).padding(4).background(.black.opacity(0.7)).clipShape(Capsule())
            Text(title).font(.caption).lineLimit(2)
            Text(age).font(.caption2).foregroundStyle(Color.creatorMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading).padding(8)
        .background(Color.creatorCard).clipShape(RoundedRectangle(cornerRadius: 12))
    }
    private var shortsSection: some View { //short section has both short card and short card has thumb nail
        HStack(alignment: .top, spacing: 10) {
            shortCard(title: "Hidden beaches of Cape Verde", views: "41.2K views",
                      age: "3 days ago", color: .blue.opacity(0.25))
            shortCard(title: "Safari gear essentials 2024", views: "28.7K views",
                      age: "1 week ago", color: .green.opacity(0.25))
        }
    }
    
}


