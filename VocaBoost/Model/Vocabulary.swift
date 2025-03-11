//
//  Instrument.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 27/2/25.
//

struct Vocab: Decodable, Identifiable, Encodable {
    let id: Int
    let name: String
    let type: String?
    let phonetic: String?
    let meaning: String?
}

