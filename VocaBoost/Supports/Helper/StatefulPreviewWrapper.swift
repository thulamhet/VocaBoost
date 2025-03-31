//
//  StatefulPreviewWrapper.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 31/3/25.
//

import SwiftUI

struct StatefulPreviewWrapper<Value, Content: View>: View {
    
    @State private var value: Value
    private let content: (Binding<Value>) -> Content

    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: value)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}
