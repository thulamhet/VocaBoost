//
//  Button+Extension.swift
//  Hiking
//
//  Created by Nguyễn Công Thư on 15/1/25.
//

import Foundation
import SwiftUI

struct GradienButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding(.vertical)
            .padding(.horizontal, 30)
            .background(
                
                configuration.isPressed ?
                LinearGradient(
                    colors: [.customGrayMedium, .customGrayLight],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ).cornerRadius(40)
                :
                LinearGradient(
                    colors: [.customGrayLight, .customGrayMedium],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ).cornerRadius(40)
            )
    }
}
