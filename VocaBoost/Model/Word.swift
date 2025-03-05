//
//  Word.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 28/2/25.
//


struct WordModel: Codable {
    let word: String
    let phonetic: String?
    let phonetics: [Phonetic]
    let meanings: [Meaning]
    let license: License
    let sourceUrls: [String]
    
    init(_ json: JSON) {
        self.word = json.word
        self.phonetic = json.phonetic
        self.phonetics = json.phonetics.arrayValue.map { Phonetic($0)}
        self.meanings = json.meanings.arrayValue.map { Meaning($0) }
        self.license = License(json: json.license)
        self.sourceUrls = json.sourceUrls.arrayValue.map { $0.stringValue }
    }
}
