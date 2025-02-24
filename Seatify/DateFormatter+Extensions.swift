//
//  DateFormatter+Extensions.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-01-22.
//

import Foundation

extension DateFormatter {
    static func dateFromDDMMYYYY(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.date(from: dateString)
    }
}
