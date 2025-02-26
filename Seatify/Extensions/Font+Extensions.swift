//
//  Font+Extensions.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-01-22.
//
import SwiftUI

extension Font {
    static func montserrat(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName: String
        switch weight {
        case .bold:
            fontName = "Montserrat-Bold"
        case .semibold:
            fontName = "Montserrat-SemiBold"
        case .medium:
            fontName = "Montserrat-Medium"
        case .light:
            fontName = "Montserrat-Light"
        case .thin:
            fontName = "Montserrat-Thin"
        default:
            fontName = "Montserrat-Regular"
        }
        return .custom(fontName, size: size)
    }
}
