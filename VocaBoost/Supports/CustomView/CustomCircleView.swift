//
//  CustomCircleView.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 11/3/25.
//

import SwiftUI

struct CustomCircleView: View {
    @State private var isAnimateGradient: Bool = false
    
    var body: some View {
        ZStack {
            
            Circle()
                .fill(
                LinearGradient(
                    colors: [.customIndigoMedium, .customSalmonLight],
                    startPoint: isAnimateGradient ? .topLeading : .bottomLeading,
                    endPoint: isAnimateGradient ? .bottomTrailing : .topTrailing
                )
            )
            .onAppear {
                withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: true)) {
                    isAnimateGradient.toggle()
                }
            }
            MotionAnimationView()
        }.frame(width: 500, height: 500)
    }
}

#Preview {
    CustomCircleView()
}
