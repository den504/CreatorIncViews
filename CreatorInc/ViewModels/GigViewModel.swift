//
//  GigViewModel.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 25/07/2026.
//

import  Foundation
import Combine

@MainActor

class GigViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var budgetText: String = ""
    @Published var brief: String = ""
    @Published var closesAt: Date = Date().addingTimeInterval(7 * 86400)
    @Published var requirementsText: String = ""
    @Published var deliverablesText: String = ""
    @Published var selectedTags: [String] = []
    @Published var message: String?
    
    @Published private(set) var isLoading = false
    private let gigService: GigServicing
    private let validator = GigValidator()
    let tagOptions = ["Technology" , "Travel", "Lifestyle" , "Fitness"]
    
    init(gigService: GigServicing) {
        self.gigService = gigService
    }
    
    func save() async -> Gig? {
        message = nil
        isLoading = true
        
        defer {isLoading = false}
        
        do {
            let validTitle = try validator.validateTitle(title)
            let validBudget = try validator.validateBudget(budgetText)
            let validBrief = try validator.validateBrief(brief)
            let requirements = validator.splitLines(requirementsText)
            let deliverables = validator.splitLines(deliverablesText)
            
            return try await gigService.createGig(title: validTitle, budget: validBudget, brief: validBrief, closesAt: closesAt, requirements:requirements, deliverables: deliverables, tags: selectedTags )
            
        }catch {
            message = error.localizedDescription
            return nil
        }

    }
    
    func toggleTag(_ tag: String) { // only selected tags should showup eventually
        if let index = selectedTags.firstIndex(of: tag) {
            selectedTags.remove(at: index)
        }else {
            selectedTags.append(tag)
        }
    }
}
