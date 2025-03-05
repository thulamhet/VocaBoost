//
//  Phonetic.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 5/3/25.
//

struct Phonetic: Codable {
    let text: String
    let audio: String
    let sourceUrl: String?
    let license: License?
    
    init(_ json: JSON) {
        self.text = json.text
        self.audio = json.audio
        self.sourceUrl = json.sourceUrl
        self.license = License(json: json.license)
    }
}

struct License: Codable {
    let name: String
    let url: String
    
    init(json: JSON) {
        self.name = json.name
        self.url = json["url"].stringValue
    }
}
