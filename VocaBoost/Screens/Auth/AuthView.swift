//
//  AuthView.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 14/3/25.
//

import SwiftUI
import Supabase

struct AuthView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                GilroyText(viewModel.isLoginMode ? "Login" : "Sign Up", fontSize: 40, weight: .bold)
                
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .font(.custom("SVN-Gilroy", size: 16))
                    .background(.white)
                
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .font(.custom("SVN-Gilroy", size: 16))
                    .background(.white)
                
                Button(action: handleAuth) {
                    Text(viewModel.isLoginMode ? "Login" : "Sign Up")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                GilroyText(viewModel.message)
                
                Button(action: { viewModel.isLoginMode.toggle() }) {
                    GilroyText(viewModel.isLoginMode ? "Don't have an account? Sign Up" : "Already have an account? Login", fontSize: 12, color: .blue)
                }
            }
            .padding()

            ErrorPopupView()
        }.overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
    }
    
    func handleAuth() {
        Task {
            try await viewModel.emailSignIn()
            if viewModel.isLogined {
                path.append("HomeView")
            }
        }
    }
}

#Preview {
    StatefulPreviewWrapper(NavigationPath()) { path in
        AuthView(path: path)
    }
}
