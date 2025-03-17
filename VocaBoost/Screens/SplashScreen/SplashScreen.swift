//
//  SplashScreen.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 11/3/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var opacity = 1.0
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ZStack {
            Color.init(hex: "#C3CEDA").ignoresSafeArea()
            VStack {
                Image("LaunchImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .cornerRadius(100)
                    .foregroundColor(.white)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 150, height: 150)
                    )
                GilroyText("By Nguyen Cong Thu", fontSize: 25, color: Color.darkBlue, weight: .semiBold).padding()
            }
            .opacity(opacity)
            .scaleEffect(scale)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeOut(duration: 0.8)) {
                        opacity = 0
                        scale = 0.8
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        isActive = true
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $isActive) {
//            HomeView(viewModel: .init())
            AuthView(viewModel: .init())
                .transition(.opacity) // Optional smooth transition
        }
    }
}

#Preview {
    SplashScreenView()
}
