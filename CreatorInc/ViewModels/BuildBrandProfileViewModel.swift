//
//  BuildBrandProfileViewModel.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 11/07/2026.
//

import Foundation
import Combine

@MainActor
class BuildBrandProfileViewModel: ObservableObject {
    @Published var companyName: String = ""
    @Published var brandIntro: String = ""
    @Published var selectedIndustries: [String] = []
    @Published var website: String = ""
    @Published var location: String = ""
    @Published var targetCreatorNiches: [String] = []
    
    let industries = ["Skincare", "Wellness", "Fashion", "Tech", "Food", "Travel"]
    let niches = ["Travel", "LifeStyle", "Fitness", "Beauty"]

}
