//
//  AccountRole.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 16/06/2026.
//

import Foundation

enum AccountRole: String, CaseIterable, Identifiable {
    case creator = "Creator"
    case brand = "Brand"

    var id: String { rawValue }
}
