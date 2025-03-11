//
//  MotionAnimationView.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 11/3/25.
//

import SwiftUI

struct MotionAnimationView: View {
  // MARK: - PROPERTIES
  
  @State private var randomCircle: Int = Int.random(in: 6...12)
  @State private var isAnimating: Bool = false
  
  // MARK: - FUNCTIONS
  
  func randomCoordinate() -> CGFloat {
    return CGFloat.random(in: 0...256)
  }
  
  func randomSize() -> CGFloat {
    return CGFloat(Int.random(in: 4...80))
  }
  
  func randomScale() -> CGFloat {
    return CGFloat(Double.random(in: 0.1...2.0))
  }
  
  func randomSpeed() -> Double {
    return Double.random(in: 0.05...1.0)
  }
  
  func randomDelay() -> Double {
    return Double.random(in: 0...2)
  }
  
  var body: some View {
    ZStack {
      ForEach(0...randomCircle, id: \.self) { item in
        Circle()
          .foregroundColor(.white)
          .opacity(0.25)
          .frame(width: randomSize())
          .position(
            x: randomCoordinate(),
            y: randomCoordinate()
          )
          .scaleEffect(isAnimating ? randomScale() : 1)
          .onAppear(perform: {
            withAnimation(
              .interpolatingSpring(stiffness: 0.25, damping: 0.25)
              .repeatForever()
              .speed(randomSpeed())
              .delay(randomDelay())
            ) {
              isAnimating = true
            }
          })
      }
    } //: ZSTACK
    .frame(width: 300, height: 300)
    .mask(Circle())
    .drawingGroup()
  }
}

#Preview {
    ZStack {
        Color.teal.ignoresSafeArea()
        MotionAnimationView()
    }
}
