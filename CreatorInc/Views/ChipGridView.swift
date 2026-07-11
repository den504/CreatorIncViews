//
//  ChipGridView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 11/07/2026.
//

import SwiftUI

struct ChipGridView: View {
    let options: [String]
    @Binding var selected: [String]
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 92), spacing: 10)], spacing: 10){
            ForEach(options,  id: \.self){option in
                Button {
                    if selected.contains(option){
                        selected = selected.filter{ $0 != option }
                    } else {
                        selected.append(option)
                    }
                } label: {
                    Text(option)
                        .font(.system(size: 13, weight: .bold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .foregroundStyle(selected.contains(option) ? .white : .gray)
                        .background {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(selected.contains(option) ? Color.blue : Color.gray.opacity(0.2))
                        }
                }
            }
        }
    }
}
