//
//  RestaurantReservationView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-27.
//

import SwiftUI

struct RestaurantReservationTabView: View {
    let restaurant: Restaurant
    @StateObject private var viewModel = RestaurantDetailViewModel()
    @State private var selectedDate: Date = Date()
    @State private var guestCount: Int = 2
    @State private var selectedSlot: SlotResponse? = nil
    @State private var additionalRequests: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Date")
                .font(.montserrat(size: 16, weight: .bold))
                .foregroundColor(Color("PrimaryFont"))
            
            HStack {
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
            }
            .onChange(of: selectedDate) { oldValue, newValue in
                viewModel.fetchAvailableSlots(for: restaurant.id, guests: guestCount, date: selectedDate)
            }
            
            Text("Guests")
                .font(.montserrat(size: 16, weight: .bold))
                .foregroundColor(Color("PrimaryFont"))
            
            HStack {
                Button(action: {
                    if guestCount > 1 {
                        guestCount -= 1
                        viewModel.fetchAvailableSlots(for: restaurant.id, guests: guestCount, date: selectedDate)
                    }
                }) {
                    Image(systemName: "minus.circle")
                        .foregroundColor(.gray)
                }
                
                Text("\(guestCount)")
                    .font(.montserrat(size: 16))
                    .frame(width: 40, alignment: .center)
                    .foregroundColor(Color("PrimaryFont"))
                
                Button(action: {
                    guestCount += 1
                    viewModel.fetchAvailableSlots(for: restaurant.id, guests: guestCount, date: selectedDate)
                }) {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.gray)
                }
            }
            
            Text("Available Slots")
                .font(.montserrat(size: 16, weight: .bold))
                .foregroundColor(Color("PrimaryFont"))

            if viewModel.isLoading {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else if viewModel.availableSlots.isEmpty {
                Text("No slots available")
                    .font(.montserrat(size: 14))
                    .foregroundColor(.gray)
                    .padding()
            } else {
                VStack {
                    ForEach(viewModel.availableSlots, id: \.id) { slot in
                        Button(action: { selectedSlot = slot }) {
                            HStack {
                                Text("\(slot.time) - Table \(slot.table)")
                                    .font(.montserrat(size: 14))
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .background(selectedSlot?.id == slot.id ? Color.green : Color.gray.opacity(0.2))
                            .cornerRadius(6)
                        }
                    }
                }
            }
            
            Text("Comments")
                .font(.montserrat(size: 16, weight: .bold))
                .foregroundColor(Color("PrimaryFont"))
            
            TextField("Additional Requests...", text: $additionalRequests)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color("BackgroundColor"))
            
            NavigationLink(destination: PaymentScreen(reservationDetails: ReservationRequest(
                restaurant_id: restaurant.id,
                slot_id: selectedSlot?.id ?? 0,
                number_of_guests: guestCount,
                comments: additionalRequests
            ))) {
                Text("Reserve Your Seat")
                    .font(.montserrat(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedSlot == nil ? Color.gray : Color.green)
                    .cornerRadius(10)
            }
            .disabled(selectedSlot == nil)
            .padding(.top, 10)
        }
        .padding()
        .onAppear {
            viewModel.fetchAvailableSlots(for: restaurant.id, guests: guestCount, date: selectedDate)
        }
    }
}

