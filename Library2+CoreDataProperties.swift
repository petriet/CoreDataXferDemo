//
//  Library2+CoreDataProperties.swift
//  CoreDataXferDemo
//
//  Created by Tracy Petrie on 7/18/17.
//  Copyright © 2017 Tracy Petrie. All rights reserved.
//

import Foundation
import CoreData


extension Library2 {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Library2> {
        return NSFetchRequest<Library2>(entityName: "Library2")
    }

    @NSManaged public var libraryName: String?
    @NSManaged public var libraryUUID: String?
    @NSManaged public var hasBooks: NSSet?

}

// MARK: Generated accessors for hasBooks
extension Library2 {

    @objc(addHasBooksObject:)
    @NSManaged public func addToHasBooks(_ value: Book2)

    @objc(removeHasBooksObject:)
    @NSManaged public func removeFromHasBooks(_ value: Book2)

    @objc(addHasBooks:)
    @NSManaged public func addToHasBooks(_ values: NSSet)

    @objc(removeHasBooks:)
    @NSManaged public func removeFromHasBooks(_ values: NSSet)

}
