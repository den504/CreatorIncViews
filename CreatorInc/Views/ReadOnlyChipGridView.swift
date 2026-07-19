//
//  ReadOnlyChipGridView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 18/07/2026.
//

import SwiftUI

struct ReadOnlyChipGridView: View {
    let values: [String]

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 92), spacing: 10)],
                  spacing: 10) {
            ForEach(values, id: \.self) { value in
                Text(value)
                    .font(.system(size: 13, weight: .bold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .foregroundStyle(.white)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue)
                    }
            }
        }
    }
}
