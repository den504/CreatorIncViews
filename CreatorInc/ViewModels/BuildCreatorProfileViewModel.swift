//
//  BuildCreatorProfileViewModel.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 11/07/2026.
//

import Foundation
import Combine

@MainActor
class BuildCreatorProfileViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var selectedCategory: String = "Travel"
    @Published var message: String?
    let categories = ["Travel", "LifeStyle", "Beauty", "Tech", "Food"]
}
