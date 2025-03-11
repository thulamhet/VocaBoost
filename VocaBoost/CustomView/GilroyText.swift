//
//  GilroyText.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 10/3/25.
//

import SwiftUI

enum GilroyFontWeight {
    case bold
    case boldItalic
    case medium
    case mediumItalic
    case regular
    case light
    case semiBold
    case semiBoldItalic

    var fontName: String {
        switch self {
        case .bold:
            return "SVN-Gilroy Bold"
        case .boldItalic:
            return "SVN-Gilroy Bold Italic"
        case .medium:
            return "SVN-Gilroy Medium"
        case .regular:
            return "SVN-Gilroy Regular"
        case .light:
            return "SVN-Gilroy Light"
        case .mediumItalic:
            return "SVN-Gilroy Medium Italic"
        case .semiBold:
            return "SVN-Gilroy SemiBold"
        case .semiBoldItalic:
            return "SVN-Gilroy SemiBold Italic"
        }
    }
}

struct GilroyText: View {
    var text: String
    var fontSize: CGFloat
    var color: Color
    var weight: GilroyFontWeight // Enum for weight

    init(_ text: String,
         fontSize: CGFloat = 18,
         color: Color = .black,
         weight: GilroyFontWeight = .medium) {
        self.text = text
        self.fontSize = fontSize
        self.color = color
        self.weight = weight
    }

    var body: some View {
        Text(text)
            .font(.custom(weight.fontName, size: fontSize))
            .foregroundColor(color)
    }
}

#Preview {
    VStack(spacing: 10) {
        GilroyText("Bold Text") // Default is bold
        GilroyText("Medium Text", weight: .semiBold)
        GilroyText("Regular Text", weight: .regular)
        GilroyText("Light Text", fontSize: 22, color: .gray, weight: .light)
    }
    .padding()
}
