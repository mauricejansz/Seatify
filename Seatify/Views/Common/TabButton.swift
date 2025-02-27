//
//  TabButton.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-27.
//

import SwiftUI

struct TabButton: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.montserrat(size: 16, weight: isSelected ? .bold : .regular))
                .foregroundColor(isSelected ? .green : .gray)
                .underline(isSelected, color: .green)
        }
        .padding(.horizontal, 8)
    }
}

