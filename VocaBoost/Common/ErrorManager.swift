//
//  ErrorManager.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 10/3/25.
//

import SwiftUI

class ErrorManager: ObservableObject {
    static let shared = ErrorManager()

    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    @MainActor
    static func showErrorPopup(_ message: String) {
        ErrorManager.shared.errorMessage = message
        withAnimation {
            ErrorManager.shared.showError = true
        }
    }
}
