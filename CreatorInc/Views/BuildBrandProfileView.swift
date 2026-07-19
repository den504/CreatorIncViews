//
//  BuildBrandProfile.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 11/07/2026.
//

import SwiftUI


struct BuildBrandProfileView: View {
    let onBack: () -> Void
    @StateObject private var viewModel: BuildBrandProfileViewModel
    let onProfileSaved: (BrandProfile) -> Void
    
    init(profile: BrandProfile? = nil,onBack: @escaping () -> Void, onProfileSaved: @escaping(BrandProfile) -> Void ) {
        self.onBack = onBack
        self.onProfileSaved = onProfileSaved
        let service: ProfileServicing
        if let config = SupabaseConfig.config {
            service = SupabaseProfileService(config: config)
        } else {
            service = UnavailableProfileService()
        }
        _viewModel = StateObject(wrappedValue: BuildBrandProfileViewModel(profileService: service, profile: profile))
    }
    
    
    var body: some View {
        ZStack {
            Color.creatorBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24){
                    header //computed property1
                    profileFields //computed property2
                    saveButton
                    
                }.foregroundStyle(.white)
            }
        }
    }
    
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8){
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                }
                Text("Back")
            }
            Text("Brand Profile Setup")
                .font(.system(size: 28, weight: .bold, design: .rounded))
            Text("Tells brands who you are")
                .font(.system(size:14, weight: .semibold))
                .foregroundStyle(.gray)
        }
    }
    
    private var profileFields: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("BRAND NAME")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.gray)
            TextField("e.g. NaturSun", text: $viewModel.companyName)
            Text("BRAND INTRO")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.gray)
            TextEditor(text: $viewModel.brandIntro)
                .frame(height: 100)
                .padding(10)
                .scrollContentBackground(.hidden)
                .background(Color.creatorInput)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(.white)
                .colorScheme(.dark)
            Text("INDUSTRY/CATEGORY")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.gray)
            ChipGridView(options: viewModel.industries, selected: $viewModel.selectedIndustries) //calls ChipView Struct
            Text("website")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.gray)
            TextField("e.g natursun.com", text: $viewModel.website)
            
            Text ("target creator niche")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.gray)
            ChipGridView(options: viewModel.niches, selected: $viewModel.targetCreatorNiches)
            
            Text ("location")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.gray)
            TextField("e.g. London, UK", text: $viewModel.location)

        }
        
        
    }
    
    private var saveButton: some View {
        Button {
            Task {
                if let profile = await viewModel.save() {
                    onProfileSaved(profile)
                }
            }
        } label: {
            Text(viewModel.isLoading ? "Saving..." : "Save and view profile")
        }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .disabled(viewModel.isLoading)
    }
    
    
    

    
}
