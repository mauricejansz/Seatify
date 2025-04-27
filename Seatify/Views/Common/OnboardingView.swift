//
//  OnboardingView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-01-22.
//
import SwiftUI

struct OnboardingView: View {
    var onGetStarted: () -> Void

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                    .frame(height: 125)

                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 110)
                    .padding()

                Spacer()

                Button(action: {
                    onGetStarted()
                }) {
                    Text("Get Started")
                        .font(.montserrat(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("PrimaryAccent"))
                        .cornerRadius(10)
                        .shadow(color: Color("PrimaryAccent").opacity(0.5), radius: 5, x: 0, y: 2)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(onGetStarted: {})
    }
}
