//
//  VocaBoostApp.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 27/2/25.
//

import SwiftUI
import Supabase
@main
struct VocaBoostApp: App {
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
    
    init() {
        Task {
            if let accessToken = UserDefaults.standard.string(forKey: "accessToken"),
               let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") {
                do {
                    try await supabase.auth.setSession(accessToken: accessToken, refreshToken: refreshToken)
                    print("✅ Session đã được khôi phục!")
                } catch {
                    print("❌ Không thể khôi phục session: \(error)")
                }
            }
        }
    }
}
