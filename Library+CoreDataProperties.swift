//
//  Library+CoreDataProperties.swift
//  CoreDataXferDemo
//
//  Created by Tracy Petrie on 7/18/17.
//  Copyright © 2017 Tracy Petrie. All rights reserved.
//

import Foundation
import CoreData


extension Library {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Library> {
        return NSFetchRequest<Library>(entityName: "Library")
    }

    @NSManaged public var libraryName: String?
    @NSManaged public var libraryID: Int64
    @NSManaged public var hasBooks: NSSet?

}

// MARK: Generated accessors for hasBooks
extension Library {

    @objc(addHasBooksObject:)
    @NSManaged public func addToHasBooks(_ value: Book)

    @objc(removeHasBooksObject:)
    @NSManaged public func removeFromHasBooks(_ value: Book)

    @objc(addHasBooks:)
    @NSManaged public func addToHasBooks(_ values: NSSet)

    @objc(removeHasBooks:)
    @NSManaged public func removeFromHasBooks(_ values: NSSet)

}
