//
//  RestaurantReservationView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-27.
//

import SwiftUI

struct RestaurantReservationView: View {
    let restaurant: Restaurant
    @StateObject private var viewModel = RestaurantDetailViewModel()
    @State private var selectedDate: Date = Date()
    @State private var guestCount: Int = 2
    @State private var selectedSlot: String? = nil
    @State private var additionalRequests: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Date")
                .font(.montserrat(size: 16, weight: .bold))
            
            HStack {
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
            }
            .onChange(of: selectedDate) { oldValue, newValue in
                viewModel.fetchAvailableSlots(for: restaurant.id, guests: guestCount)
            }
            
            Text("Guests")
                .font(.montserrat(size: 16, weight: .bold))
            
            HStack {
                Button(action: {
                    if guestCount > 1 {
                        guestCount -= 1
                        viewModel.fetchAvailableSlots(for: restaurant.id, guests: guestCount)
                    }
                }) {
                    Image(systemName: "minus.circle")
                        .foregroundColor(.gray)
                }
                
                Text("\(guestCount)")
                    .font(.montserrat(size: 16))
                    .frame(width: 40, alignment: .center)
                
                Button(action: {
                    guestCount += 1
                    viewModel.fetchAvailableSlots(for: restaurant.id, guests: guestCount)
                }) {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.gray)
                }
            }
            
            Text("Available Slots")
                .font(.montserrat(size: 16, weight: .bold))
            
            if viewModel.isLoading {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                HStack {
                    ForEach(viewModel.availableSlots, id: \.self) { slot in
                        Button(action: { selectedSlot = slot }) {
                            Text(slot)
                                .font(.montserrat(size: 14))
                                .padding()
                                .background(selectedSlot == slot ? Color.green : Color.gray.opacity(0.2))
                                .cornerRadius(6)
                        }
                    }
                }
            }
            
            Text("Comments")
                .font(.montserrat(size: 16, weight: .bold))
            
            TextField("Additional Requests...", text: $additionalRequests)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                print("Reservation Confirmed for \(guestCount) guests at \(selectedSlot ?? "N/A")")
            }) {
                Text("Reserve Your Seat")
                    .font(.montserrat(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding(.top, 10)
        }
        .padding()
        .onAppear {
            // Call API immediately when the view appears
            viewModel.fetchAvailableSlots(for: restaurant.id, guests: guestCount)
        }
    }
}

