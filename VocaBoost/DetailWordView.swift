//
//  DetailWordView.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 6/3/25.
//

import SwiftUI

struct DetailWordView: View {
    @State var word: Vocab?
    
    var body: some View {
        ZStack {
            VStack {
                Text(word?.name ?? "")
                Text(word?.meaning ?? "") 
                Text(word?.type ?? "")
                Text(word?.phonetic ?? "")
            }
        }
    }
}

#Preview {
    DetailWordView(
        word: Vocab(
            id: 1,
            name: "123",
            type: "verb",
            phonetic: "zxc",
            meaning: "ascasca"
        )
    )
}
