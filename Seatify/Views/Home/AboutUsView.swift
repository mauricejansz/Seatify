//
//  AboutUsView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-04-24.
//

import SwiftUI

struct AboutUsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("About Seatify")
                    .font(.title2.bold())
                    .foregroundColor(Color("TextColor"))
                Text("""
Seatify is a restaurant reservation app built to simplify your dining experience. Discover top restaurants, reserve tables, and explore culinary experiences from your phone.
""")
            }
            .padding()
            .foregroundColor(Color("TextColor"))
        }
        .background(Color("BackgroundColor"))
    }
}
