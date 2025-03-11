//
//  ErrorPopupView.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 10/3/25.
//

import SwiftUI

struct ErrorPopupView: View {
    
    @ObservedObject var errorManager = ErrorManager.shared
    
    var body: some View {
        if errorManager.showError {
            ZStack {
                VStack {
                    HStack {
                        Image("error")
                            .resizable()
                            .frame(width: 40, height: 40)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            GilroyText("Something went wrong!", fontSize: 20, weight: .bold)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            GilroyText(errorManager.errorMessage)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button(action: {
                            withAnimation {
                                errorManager.showError.toggle()
                            }
                        }) {
                            Image("close")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.init(hex: "#FCEFEA"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.init(hex: "#ECCEC6"), lineWidth: 5)
                    )
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                    .shadow(radius: 5)
                }
                .frame(maxWidth: .infinity)
                .transition(.move(edge: .bottom))
                .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .background(Color.black.opacity(errorManager.showError ? 0.3 : 0).ignoresSafeArea())
            .onTapGesture {
                withAnimation {
                    errorManager.showError.toggle()
                }
            }
        }
    }
}

struct ContentView: View {
    @State private var showError = false

    var body: some View {
        ZStack {
            VStack {
                Button("Show Error") {
                    showError = true
                }
                .buttonStyle(.borderedProminent)
            }

//            ErrorPopupView(isPresented: $showError, errorMessage: "Something went wrong. Please try again.")
        }
    }
}

#Preview {
    ContentView()
}
