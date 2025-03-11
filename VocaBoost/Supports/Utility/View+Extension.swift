//
//  View+Extension.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 10/3/25.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
