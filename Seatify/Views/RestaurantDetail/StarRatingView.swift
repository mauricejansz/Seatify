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
    var isSelectable: Bool = false
    var onRatingSelected: ((Double) -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<5, id: \.self) { index in
                let starValue = rating - Double(index)

                Image(getStarImage(for: starValue))
                    .resizable()
                    .frame(width: starSize, height: starSize)
                    .onTapGesture {
                        if isSelectable {
                            onRatingSelected?(Double(index) + 1)
                        }
                    }
            }
        }
    }

    private func getStarImage(for starValue: Double) -> String {
        if starValue >= 1.0 {
            return "star_100"
        } else if starValue >= 0.75 {
            return "star_75"
        } else if starValue >= 0.5 {
            return "star_50"
        } else if starValue >= 0.25 {
            return "star_25"
        } else {
            return "star_0"
        }
    }
}
