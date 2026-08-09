//
//  CreatorMyGigsViewModel.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 08/08/2026.
//

import Combine
import Foundation

@MainActor
final class CreatorMyGigsViewModel: ObservableObject {
    @Published private(set) var gigs: [Gig] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    private let service: GigInterestServicing
    
    
    init(service: GigInterestServicing){
        self.service = service
    }
    
    func load() async {
        guard !isLoading else { return }
        errorMessage = nil
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do{
            gigs = try await service.fetchInterestedGigs()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
