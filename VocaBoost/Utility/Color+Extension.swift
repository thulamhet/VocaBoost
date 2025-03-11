//
//  Color+Extension.swift
//  Hiking
//
//  Created by Nguyễn Công Thư on 15/1/25.
//

import SwiftUI
import Foundation

extension Color {
    static let customGreenLight = Color("ColorGreenLight")
    static let customGreenMedium = Color("ColorGreenMedium")
    static let customGreenDark = Color("ColorGreenDark")
    static let customGrayLight = Color("ColorGrayLight")
    static let customGrayMedium = Color("ColorGrayMedium")
    static let customIndigoMedium = Color("ColorIndigoMedium")
    static let customSalmonLight = Color("ColorSalmonLight")
    
    init(hex: String) {
        let hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexSanitized)
        
        if hexSanitized.hasPrefix("#") {
            scanner.currentIndex = hexSanitized.index(after: hexSanitized.startIndex)
        }

        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = Double((rgbValue >> 16) & 0xFF) / 255.0
        let g = Double((rgbValue >> 8) & 0xFF) / 255.0
        let b = Double(rgbValue & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}
