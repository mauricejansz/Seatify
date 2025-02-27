//
//  RestaurantReviewView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-27.
//

import SwiftUI

struct RestaurantReviewView: View {
    let restaurantId: Int
    @StateObject private var viewModel = ReviewViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else if viewModel.reviews.isEmpty {
                    Text("No reviews yet. Be the first to add a review!")
                        .font(.montserrat(size: 16))
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    // 🔹 Rating Summary
                    HStack(alignment: .center, spacing: 8) {
                        VStack(alignment: .center) {
                            Text("\(String(format: "%.1f", viewModel.averageRating))")
                                .font(.montserrat(size: 60, weight: .bold))
                            Text("Rating")
                                .font(.montserrat(size: 16))
                                .foregroundColor(Color("PrimaryFont"))
                        }
                        VStack(alignment: .center) {
                            StarRatingView(rating: viewModel.averageRating, starSize: 50)
                            Text("\(viewModel.reviews.count) Reviews")
                                .font(.montserrat(size: 16))
                                .foregroundColor(Color("PrimaryFont"))
                        }
                        
                        
                    }
                    .padding(.bottom, 2)
                    
                    Divider()
                    
                    // 🔹 Reviews List
                    VStack(spacing: 12) {
                        ForEach(viewModel.reviews) { review in
                            ReviewCardView(review: review)
                        }
                    }
                }
                
                // 🔹 Add Review Button
                Button(action: {
                    print("Navigate to add review screen")
                }) {
                    Text("Add Your Review")
                        .font(.montserrat(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .padding(.top, 10)
        }
        .onAppear {
            viewModel.fetchReviews(for: restaurantId)
        }
    }
}

// 🔹 Review Card View (Updated for Full Width)
struct ReviewCardView: View {
    let review: Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(review.name)
                .font(.montserrat(size: 16, weight: .bold))
            
            StarRatingView(rating: review.rating, starSize: 16)
            
            Text("\"\(review.comment)\"")
                .font(.montserrat(size: 14))
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading) // Full width
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12)) // Proper rounded edges
        .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 2) // Soft shadow
        .padding(.horizontal, 20) // Consistent padding
    }
}
