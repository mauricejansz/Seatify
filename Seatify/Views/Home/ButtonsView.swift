//
//  ButtonsView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-04-24.
//

import SwiftUI

struct ButtonView: View {
    var label: String
    var systemImage: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: systemImage)
                Text(label)
            }
            .font(.montserrat(size: 14))
            .foregroundColor(Color("TextColor"))
            .frame(maxWidth: .infinity)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color("TextColor"), lineWidth: 1)
            )
        }
    }
}
