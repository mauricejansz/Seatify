//
//  LoadingView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-04-24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                Text("Loading...")
                    .foregroundColor(.white)
                    .padding(.top, 8)
            }
        }
    }
}
