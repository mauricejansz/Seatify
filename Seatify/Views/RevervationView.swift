//
//  RevervationView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-26.
//

import SwiftUI

struct ReservationsView: View {
    @StateObject private var viewModel = ReservationsViewModel()

    var body: some View {
        Group {
            if viewModel.activeReservations.isEmpty && viewModel.pastReservations.isEmpty {
                VStack {
                    Spacer()

                    VStack(spacing: 20) {
                        Text("Upcoming Reservations")
                            .font(.montserrat(size: 20, weight: .bold))
                            .foregroundColor(Color("TextColor"))

                        Text("No upcoming reservations.")
                            .foregroundColor(.gray)

                        Text("Past Reservations")
                            .font(.montserrat(size: 20, weight: .bold))
                            .padding(.top, 10)
                            .foregroundColor(Color("TextColor"))

                        Text("No past reservations.")
                            .foregroundColor(.gray)
                    }

                    Spacer()
                }
                .frame(maxHeight: .infinity)
                .frame(maxWidth: .infinity)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Upcoming Reservations")
                            .font(.montserrat(size: 20, weight: .bold))
                            .padding(.horizontal)
                            .foregroundColor(Color("TextColor"))

                        if viewModel.activeReservations.isEmpty {
                            Text("No upcoming reservations.")
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                        } else {
                            ForEach(viewModel.activeReservations) { reservation in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(reservation.formattedDateTime)
                                        .font(.montserrat(size: 14, weight: .medium))
                                        .foregroundColor(.gray)
                                        .padding(.horizontal)
                                        .frame(maxWidth: .infinity, alignment: .center)

                                    RestaurantSearchCard(restaurant: reservation.restaurant)
                                        .padding(.horizontal)
                                }
                            }
                        }

                        Text("Past Reservations")
                            .font(.montserrat(size: 20, weight: .bold))
                            .padding([.top, .horizontal])
                            .foregroundColor(Color("TextColor"))

                        if viewModel.pastReservations.isEmpty {
                            Text("No past reservations.")
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                        } else {
                            ForEach(viewModel.activeReservations) { reservation in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(reservation.formattedDateTime)
                                        .font(.montserrat(size: 14, weight: .medium))
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity, alignment: .center)

                                    RestaurantSearchCard(restaurant: reservation.restaurant)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .onAppear {
            viewModel.fetchReservations()
        }
        .background(Color("BackgroundColor").ignoresSafeArea())
    }
}
