//
//  BuildCreatorProfileView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 07/07/2026.
//

import SwiftUI
import PhotosUI

struct BuildCreatorProfileView: View {
    let onBack: ()  -> Void
    @StateObject private var viewModel: BuildCreatorProfileViewModel
    let onProfileSaved: (CreatorProfile) -> Void
    @State private var selectedPhotoItem: PhotosPickerItem?
    
    //The custom init is used to create the view model with the required service before the view appears
    init(profile: CreatorProfile? = nil, onBack: @escaping() -> Void, onProfileSaved: @escaping(CreatorProfile)-> Void){
        self.onBack = onBack
        let config = SupabaseConfig.config
        let service: ProfileServicing
        self.onProfileSaved = onProfileSaved
        
        if let config {
            service = SupabaseProfileService(config: config)
        }else{
            service = UnavailableProfileService()
        }
        
        _viewModel = StateObject(wrappedValue: BuildCreatorProfileViewModel(profileService: service, profile: profile))
    }

    var body: some View {
        ZStack {
            Color.creatorBackground.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                header
                    .padding(.bottom, 24)

                photoButton
                    .padding(.bottom, 22)

                profileFields
                    .padding(.bottom, 20)

                if let message = viewModel.message {
                    Text(message)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.creatorSecondaryText)
                        .padding(.bottom, 12)
                }

                saveButton

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 34)
            .padding(.top, 28)
            .frame(maxWidth: 420, maxHeight: .infinity, alignment: .top)
        }
    }


    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8){
                Button(action: onBack){
                    Image(systemName: "chevron.left")
                }
                Text("Back")
                    .foregroundStyle(.white)
            }
            Text("Build your profile")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("Add the basics creators will see first")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.creatorMuted)
        }
    }

    private var photoButton: some View {
        //opens photo library, loads and prepares the selected photo
        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
            VStack(spacing: 8) {
                photoPreview
                    .frame(width: 92, height: 92)
                    .clipShape(Circle())
                    .overlay { Circle().stroke(Color.white.opacity(0.2)) }
                Text("Add or change photo")
                    .font(.system(size: 12, weight: .bold))
            }
            .foregroundStyle(Color.creatorSecondaryText)
        }
        .task(id: selectedPhotoItem) { //helper to compress image
            guard let item = selectedPhotoItem else { return }
            guard let data = try? await item.loadTransferable(type: Data.self),//photo transforms to Data
                  let jpegData = ProfileImageProcessor.jpegData(from: data) else {
                viewModel.message = "Could not load that photo."
                return
            }
            viewModel.selectedPhotoJPEGData = jpegData
            viewModel.message = nil
        }
    }
    
    @ViewBuilder
    private var photoPreview: some View { //displays the selected photo
        if let data = viewModel.selectedPhotoJPEGData,
           let image = UIImage(data: data) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } else if let urlText = viewModel.profilePhotoURL,
                  let url = URL(string: urlText) {
            AsyncImage(url: url) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Image(systemName: "person.crop.circle")
            }
        } else {
            Image(systemName: "camera.fill")
        }
    }

    private var profileFields: some View {
        VStack(alignment: .leading, spacing: 14) {
            ProfileFieldLabel("Full name")

            AccountTextField(
                title: "Jess Miller",
                systemImage: "person.fill",
                text: $viewModel.fullName
            )
            
            ProfileFieldLabel("About you")

            TextEditor(text: $viewModel.bio) 
                .frame(height: 100)
                .padding(10)
                .scrollContentBackground(.hidden)
                .background(Color.creatorInput)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(.white)

            ProfileFieldLabel("Category")

            categoryGrid
        }
    }

   
    private var categoryGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 92), spacing: 10)], spacing: 10) {
            ForEach(viewModel.categories, id: \.self) { category in
                Button {
                    viewModel.selectedCategory = category
                } label: {
                    Text(category)
                        .frame(maxWidth: .infinity)
                        .frame(height: 38)
                }
                .buttonStyle(CategoryChipStyle(isSelected: viewModel.selectedCategory == category))
            }
        }
    }

    private var saveButton: some View {
        Button {
//            viewModel.message = viewModel.fullName.isEmpty ? "Add your full name to continue." : "Profile form is ready to save."
            Task{
                if let profile = await viewModel.save(){
                    onProfileSaved(profile)
                }
            }
        } label: {
            Text(viewModel.isLoading ? "Saving..." : "Save & Continue")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(PrimaryActionButtonStyle()).disabled(viewModel.isLoading)
    }
}

private struct ProfileFieldLabel: View {
    let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title.uppercased())
            .font(.system(size: 11, weight: .bold))
            .foregroundStyle(Color.creatorMuted)
    }
}

private struct CategoryChipStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 13, weight: .bold))
            .foregroundStyle(isSelected ? .white : Color.creatorSecondaryText)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(isSelected ? Color.creatorPrimary : Color.creatorButton)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.white.opacity(isSelected ? 0 : 0.08), lineWidth: 1)
                    }
            }
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.75), value: configuration.isPressed)
    }
}
