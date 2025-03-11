//
//  CustomBackgroundView.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 10/3/25.
//

import SwiftUI

struct CustomBackgroundView: View {
    var body: some View {
        ZStack {
            Color.customGreenDark
                .offset(y: 12)
            
            Color.customGreenLight
                .offset(y: 3)
                .opacity(0.85)
            
            LinearGradient(
                colors: [.customGreenLight, .customGreenMedium],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}

#Preview {
    CustomBackgroundView().padding()
}
