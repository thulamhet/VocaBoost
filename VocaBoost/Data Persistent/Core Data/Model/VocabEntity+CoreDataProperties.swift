//
//  VocabEntity+CoreDataProperties.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 19/3/25.
//
//

import Foundation
import CoreData


extension VocabEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VocabEntity> {
        return NSFetchRequest<VocabEntity>(entityName: "VocabEntity")
    }

    @NSManaged public var id: Int
    @NSManaged public var meaning: String?
    @NSManaged public var name: String?
    @NSManaged public var phonetic: String?
    @NSManaged public var type: String?

}

extension VocabEntity : Identifiable {

}
