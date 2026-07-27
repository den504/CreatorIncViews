//
//  AccountRole.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 16/06/2026.
//

import Foundation

nonisolated enum AccountRole: String, CaseIterable, Identifiable, Codable, Sendable {
    case creator
    case brand

    var id: String { rawValue }
    
    var title: String {
        rawValue.capitalized
    }
}


