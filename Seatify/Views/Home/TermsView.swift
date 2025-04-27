//
//  TermsView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-04-24.
//

import SwiftUI

struct TermsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Terms & Conditions")
                    .font(.title2.bold())
                    .foregroundColor(Color("TextColor"))
                Text("""
By using Seatify, you agree to our terms of service and privacy policies. Users are responsible for reservation accuracy and punctuality.
""")
            }
            .padding()
            .foregroundColor(Color("TextColor"))
        }
        .background(Color("BackgroundColor"))
    }
}
