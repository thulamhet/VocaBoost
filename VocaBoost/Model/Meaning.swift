//
//  Meaning.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 5/3/25.
//

struct Meaning: Codable {
    let partOfSpeech: String
    let definitions: [Definition]
    let synonyms: [String]
    let antonyms: [String]
    
    init(_ json: JSON) {
        self.partOfSpeech = json.partOfSpeech
        self.definitions = json.definitions.arrayValue.map { Definition($0)}
        self.synonyms = json.synonyms.arrayValue.map { $0.stringValue }
        self.antonyms = json.antonyms.arrayValue.map { $0.stringValue }
    }
}

struct Definition: Codable {
    let definition: String
    let synonyms: [String]
    let antonyms: [String]
    
    init(_ json: JSON) {
        self.definition = json.definition
        self.synonyms = json.synonyms.arrayValue.map { $0.stringValue }
        self.antonyms = json.antonyms.arrayValue.map { $0.stringValue }
    }
}
