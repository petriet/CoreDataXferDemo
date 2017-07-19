//
//  Book2+CoreDataProperties.swift
//  CoreDataXferDemo
//
//  Created by Tracy Petrie on 7/18/17.
//  Copyright © 2017 Tracy Petrie. All rights reserved.
//

import Foundation
import CoreData


extension Book2 {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book2> {
        return NSFetchRequest<Book2>(entityName: "Book2")
    }

    @NSManaged public var title: String?
    @NSManaged public var bookUUID: String?
    @NSManaged public var currentlyAvailable: Int16
    @NSManaged public var totalAvailable: Int16
    @NSManaged public var checkedOut: NSSet?
    @NSManaged public var ownedBy: Library2?

}

// MARK: Generated accessors for checkedOut
extension Book2 {

    @objc(addCheckedOutObject:)
    @NSManaged public func addToCheckedOut(_ value: Loan2)

    @objc(removeCheckedOutObject:)
    @NSManaged public func removeFromCheckedOut(_ value: Loan2)

    @objc(addCheckedOut:)
    @NSManaged public func addToCheckedOut(_ values: NSSet)

    @objc(removeCheckedOut:)
    @NSManaged public func removeFromCheckedOut(_ values: NSSet)

}
