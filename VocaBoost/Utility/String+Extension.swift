//
//  String+Extension.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 10/3/25.
//

extension String {
    static let empty: String = ""
    static let space: String = " "
    static let zero: String = "0"
    static let one: String = "1"
    
    var notEmpty: Bool { return !isEmpty }
    
    var intValue: Int {
        return Int(self) ?? 0
    }
    
    var formatPhonetic: String {
        return self.replacingOccurrences(of: "ɹ", with: "r").replacingOccurrences(of: "ɒ", with: "ɑ")
    }
}
