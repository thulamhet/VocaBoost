//
//  AuthViewModel.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 14/3/25.
//

import Supabase
import Combine

final class AuthViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var isLoginMode = true
    @Published var message = ""
    
    @MainActor
    func emailSignIn() async throws {
        do {
            if isLoginMode {
                let response = try await supabase.auth.signIn(email: email, password: password)
                print(response)
//                    message = "Login Success! User ID: \(response.session?.user.id ?? "No ID")"
            } else {
                let response = try await supabase.auth.signUp(email: email, password: password)
                message = "Sign Up Success! Check your email."
            }
        } catch {
            ErrorManager.showErrorPopup(error.localizedDescription)
            dump(error)
        }
    }
}

