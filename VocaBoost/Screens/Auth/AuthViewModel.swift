//
//  AuthViewModel.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 14/3/25.
//

import Supabase
import Combine

final class AuthViewModel: ObservableObject {
    
    @Published var email = "congthu137@gmail.com"
    @Published var password = "1"
    @Published var isLoginMode = true
    @Published var message = ""
    @Published var isLogined = false
    @Published var isLoading: Bool = false
    
    @MainActor
    func emailSignIn() async throws {
        do {
            isLoading = true
            defer { isLoading = false }
            
            if isLoginMode {
                let session: Auth.Session = try await supabase.auth.signIn(email: email, password: password)
                print("-- SIGN IN SUCCESS: \n", session)
                KeychainService.saveSession(session.refreshToken)
                isLogined = true
            } else {
                try await supabase.auth.signUp(email: email, password: password)
                message = "Sign Up Success! Check your email."
            }
        } catch {
            ErrorManager.showErrorPopup(error.localizedDescription)
            dump(error)
        }
    }
    
    @MainActor
    func signOut() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await supabase.auth.signOut()
            print("-- SIGN OUT SUCCESS: \n")
            isLogined = false
        } catch {
            ErrorManager.showErrorPopup(error.localizedDescription)
            dump(error)
        }
    }
}

