//
//  StarRatingView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-27.
//

import SwiftUI

struct StarRatingView: View {
    let rating: Double
    let starSize: CGFloat

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<5) { index in
                let starValue = rating - Double(index)

                if starValue >= 1.0 {
                    Image("star_100") // Full star
                        .resizable()
                        .frame(width: starSize, height: starSize)
                } else if starValue >= 0.75 {
                    Image("star_75") // Three-quarter star
                        .resizable()
                        .frame(width: starSize, height: starSize)
                } else if starValue >= 0.5 {
                    Image("star_50") // Half star
                        .resizable()
                        .frame(width: starSize, height: starSize)
                } else if starValue >= 0.25 {
                    Image("star_25") // One-quarter star
                        .resizable()
                        .frame(width: starSize, height: starSize)
                } else {
                    Image("star_0") // Empty star
                        .resizable()
                        .frame(width: starSize, height: starSize)
                }
            }
        }
    }
}
