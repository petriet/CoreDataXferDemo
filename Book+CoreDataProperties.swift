//
//  Book+CoreDataProperties.swift
//  CoreDataXferDemo
//
//  Created by Tracy Petrie on 7/18/17.
//  Copyright © 2017 Tracy Petrie. All rights reserved.
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var title: String?
    @NSManaged public var bookID: Int64
    @NSManaged public var belongsTo: Library?
    @NSManaged public var borrowedBy: NSSet?

}

// MARK: Generated accessors for borrowedBy
extension Book {

    @objc(addBorrowedByObject:)
    @NSManaged public func addToBorrowedBy(_ value: Patron)

    @objc(removeBorrowedByObject:)
    @NSManaged public func removeFromBorrowedBy(_ value: Patron)

    @objc(addBorrowedBy:)
    @NSManaged public func addToBorrowedBy(_ values: NSSet)

    @objc(removeBorrowedBy:)
    @NSManaged public func removeFromBorrowedBy(_ values: NSSet)

}
