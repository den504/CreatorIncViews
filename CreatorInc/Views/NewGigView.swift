//
//  GigView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 25/07/2026.
//

import SwiftUI

struct NewGigView: View {
    @StateObject private var viewModel: GigViewModel
    @Environment(\.dismiss) private var dismiss
    let onGigCreated: (Gig) -> Void
    
    init(onGigCreated: @escaping (Gig)-> Void ){
        self.onGigCreated = onGigCreated
        let service: GigServicing
        
        if let config = SupabaseConfig.config {
            service = SupabaseGigService(config: config)
        } else {
            service = UnavailableGigService()
        }
        _viewModel = StateObject(wrappedValue: GigViewModel(gigService: service))
    }
    
    var body: some View {
        ZStack{
            Color.creatorBackground.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 24){
                    header
                    formFields
                    saveButton
                }
                .padding()
                .foregroundStyle(.white)
            }
        }
    }
    
    private var header: some View {
        HStack {
            Text("New Gig")
                .font(.system(size: 28, weight: .bold, design: .rounded))
            Spacer()
            Button("Cancel"){
                dismiss()
            }
        }
    }
    
    private var formFields: some View {
        VStack(alignment: .leading, spacing: 16){
            //title
            TextField("", text: $viewModel.title, prompt: Text("Gig title").foregroundStyle(.white.opacity(0.5)))

            
            //Budget
            TextField("", text: $viewModel.budgetText, prompt: Text("Budget").foregroundStyle(.white.opacity(0.5)))
                .keyboardType(.decimalPad)

            
            //Brief
            ZStack(alignment: .topLeading) {
                if viewModel.brief.isEmpty {
                    Text("Describe the gig...")
                        .foregroundStyle(.white.opacity(0.4))
                        .padding(.horizontal, 12)
                        .padding(.top, 16)
                    
                }
                TextEditor(text: $viewModel.brief)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 120)
                    .padding(8)
                    .background(Color.white.opacity(0.08),in: RoundedRectangle(cornerRadius: 12))
            }
            
            //calender
            DatePicker("Closes on", selection: $viewModel.closesAt, displayedComponents: .date)
                .datePickerStyle(.compact)
                .tint(.white)
            
            //requirements
            ZStack(alignment: .topLeading) {
                if viewModel.requirementsText.isEmpty {
                    Text("One requirement per line")
                        .foregroundStyle(.white.opacity(0.4))
                        .padding(.horizontal, 12)
                        .padding(.top, 16)
                }
                TextEditor(text: $viewModel.requirementsText)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 80)
                
                    .padding(8)
                    .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
            }
            
            //deliverables
            ZStack(alignment: .topLeading) {
                if viewModel.deliverablesText.isEmpty {
                    Text("One deliverable per line")
                    
                        .foregroundStyle(.white.opacity(0.4))
                        .padding(.horizontal, 12)
                        .padding(.top, 16)
                }
                TextEditor(text: $viewModel.deliverablesText)
                
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 80)
                    .padding(8)
                    .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
            }
            
            //tags
            LazyVGrid (columns: [GridItem(.adaptive(minimum: 100))], spacing: 8){
                ForEach(viewModel.tagOptions, id: \.self){ tag in
                    Button {// a button with a label for each tag on tagoptions
                        viewModel.toggleTag(tag)
                    } label: {
                        Text(tag)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(viewModel.selectedTags.contains(tag) ? Color.white : Color.white.opacity(0.08), in: Capsule())
                    .foregroundStyle (viewModel.selectedTags.contains(tag) ? Color.black : Color.white)// based on color selected it shows up
                }
            }
            
            
            
        }
    }
    private var saveButton: some View {
        VStack(spacing: 12) {
            if let message = viewModel.message { //comes at nil so if it works shouldn't show anything and @Publised on viewmodel
                //always looks to see if variable ha changed
                Text(message).foregroundStyle(.red)
            }
            
            Button {
                Task {
                    if let gig = await viewModel.save() {
                        onGigCreated(gig)
                        dismiss()
                    }//fires and goes unto next line of code, the isLoading receives false status
                }
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text("Save")
                }
                
            }
            .disabled(viewModel.isLoading)
        }
    }
}
