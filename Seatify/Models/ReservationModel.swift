//
//  ReservationModel.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-04-17.
//

import Foundation

struct Reservation: Codable, Identifiable {
    let id: Int
    let date: String
    let slot_time: String?
    let number_of_guests: Int
    let status: String
    let payment_status: String
    let restaurant: Restaurant
    
    var reservationDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: date)
    }
    
    var formattedDateTime: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMMM yyyy"

        if let dateObj = inputFormatter.date(from: date) {
            let day = Calendar.current.component(.day, from: dateObj)
            let suffix = ordinalSuffix(for: day)
            let formattedDate = outputFormatter.string(from: dateObj)
            return "\(day)\(suffix) \(formattedDate.dropFirst(2)) | \(slot_time ?? "--:--")"
        }
        return "\(date) | \(slot_time ?? "--:--")"
    }

    private func ordinalSuffix(for day: Int) -> String {
        switch day {
        case 1, 21, 31: return "st"
        case 2, 22: return "nd"
        case 3, 23: return "rd"
        default: return "th"
        }
    }
}
