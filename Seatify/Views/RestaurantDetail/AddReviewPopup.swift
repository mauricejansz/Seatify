//
//  AddReviewPopup.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-03-05.
//
import SwiftUI

struct AddReviewPopup: View {
    @Binding var isPresented: Bool
    @State private var selectedRating: Double = 0
    @State private var comment: String = ""
    let onSubmit: (Double, String) -> Void

    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)

            VStack(spacing: 16) {
                Text("Add Your Review")
                    .font(.montserrat(size: 20, weight: .bold))

                StarRatingView(rating: selectedRating, starSize: 40, isSelectable: true) { rating in
                    selectedRating = rating
                }

                TextField("Write a comment (optional)", text: $comment)
                    .padding(10)
                    .background(Color("BackgroundColor"))
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color("PrimaryFont")))
                    .foregroundColor(Color("TextColor"))

                HStack {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(.red)
                    .padding()

                    Spacer()

                    Button("Add Review") {
                        onSubmit(selectedRating, comment)
                        isPresented = false
                    }
                    .disabled(selectedRating == 0)
                    .foregroundColor(.white)
                    .padding()
                    .background(selectedRating == 0 ? Color.gray : Color.green)
                    .cornerRadius(8)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 5)
            .padding(30)
        }
    }
}
