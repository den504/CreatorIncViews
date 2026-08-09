//
//  GigInterestViewModel.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 07/08/2026.
//

import Combine
import Foundation

//setter allows read outside the Viewmodel but write only done by viewmodel
@MainActor
final class GigInterestViewModel: ObservableObject {
    @Published private(set) var hasIndicatedInterest = false
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var interestCount: Int? = nil
    @Published private(set) var interestedCreators: [CreatorProfile] = []
    @Published private(set) var isLoadingInterestedCreators = false
    @Published private(set) var interestedCreatorsError: String?


    private let service: GigInterestServicing


    var successMessage: String? {
        hasIndicatedInterest ? "Interest received!!" : nil
    }


    init(service: GigInterestServicing) {
        self.service = service
    }

    func loadInterestState(gigID: UUID) async {
        guard !isLoading else {
            return
        }

        errorMessage = nil
        isLoading = true

        defer {
            isLoading = false
        }

        do {
            let interest = try await service.fetchInterest(gigID: gigID)

            hasIndicatedInterest = interest != nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func indicateInterest(gigID: UUID) async {
        guard !isLoading,
              !hasIndicatedInterest else {
            return
        }

        errorMessage = nil
        isLoading = true

        defer {
            isLoading = false
        }

        do {
            _ = try await service.indicateInterest(gigID: gigID)
            hasIndicatedInterest = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func loadInterestCount(gigID: UUID) async {
        errorMessage = nil
        
        do {
            interestCount = try await service.fetchInterestCount(gigID: gigID)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func loadInterestedCreators(gigID: UUID) async {
        guard !isLoadingInterestedCreators else {
            return
        }
        interestedCreatorsError = nil
        isLoadingInterestedCreators = true
        defer {
            isLoadingInterestedCreators = false
        }
        do {
            interestedCreators = try await service.fetchInterestedCreators(gigID: gigID)
        } catch {
            interestedCreatorsError = error.localizedDescription
        }
    }
    
    
}
