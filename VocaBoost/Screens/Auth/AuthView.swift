//
//  AuthView.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 14/3/25.
//

import SwiftUI
import Supabase

struct AuthView: View {
    
    @StateObject var viewModel: AuthViewModel = .init()
    @State private var path: [String] = []
    
    var body: some View {
        NavigationStack(path: $path) {
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
                    }.onChange(of: viewModel.isLogined) { oldValue, newValue in
                        if newValue {
                            path.append("home")
                        }
                    }
                    
                    GilroyText(viewModel.message)
                    
                    Button(action: { viewModel.isLoginMode.toggle() }) {
                        GilroyText(viewModel.isLoginMode ? "Don't have an account? Sign Up" : "Already have an account? Login", fontSize: 12, color: .blue)
                    }
                }
                .padding()
                .navigationDestination(for: String.self) { value in
                    if value == "home" {
                        HomeView()
                    }
                }
                ErrorPopupView()
            }.overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
        }
    }
    
    func handleAuth() {
        Task {
            try await viewModel.emailSignIn()
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(viewModel: .init())
    }
}
