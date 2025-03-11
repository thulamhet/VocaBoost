//
//  CustomButton.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 28/2/25.
//

import SwiftUI

struct CustomButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(12)
                .shadow(radius: 5)
        }
        .padding(.horizontal, 20)
    }
}
