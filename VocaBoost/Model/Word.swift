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
    
    var meaning: String {
        meanings.first?.definitions.first?.definition ?? ""
    }
    
    var type: String {
        meanings.first?.partOfSpeech ?? ""
    }
    
    func toVocabModel() -> Vocab {
        let random = Int.random(in: 1...100)
        let voc: Vocab = .init(
            id: random,
            name: word,
            type: type,
            phonetic: phonetic?.formatPhonetic,
            meaning: meaning
        )
        return voc
    }
    
    init(_ json: JSON) {
        self.word = json.word
        self.phonetic = json.phonetic
        self.phonetics = json.phonetics.arrayValue.map { Phonetic($0)}
        self.meanings = json.meanings.arrayValue.map { Meaning($0) }
        self.license = License(json: json.license)
        self.sourceUrls = json.sourceUrls.arrayValue.map { $0.stringValue }
    }
}
