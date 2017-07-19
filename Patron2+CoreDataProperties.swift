//
//  Patron2+CoreDataProperties.swift
//  CoreDataXferDemo
//
//  Created by Tracy Petrie on 7/18/17.
//  Copyright © 2017 Tracy Petrie. All rights reserved.
//

import Foundation
import CoreData


extension Patron2 {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Patron2> {
        return NSFetchRequest<Patron2>(entityName: "Patron2")
    }

    @NSManaged public var name: String?
    @NSManaged public var partronCard: String?
    @NSManaged public var checksOut: NSSet?

}

// MARK: Generated accessors for checksOut
extension Patron2 {

    @objc(addChecksOutObject:)
    @NSManaged public func addToChecksOut(_ value: Loan2)

    @objc(removeChecksOutObject:)
    @NSManaged public func removeFromChecksOut(_ value: Loan2)

    @objc(addChecksOut:)
    @NSManaged public func addToChecksOut(_ values: NSSet)

    @objc(removeChecksOut:)
    @NSManaged public func removeFromChecksOut(_ values: NSSet)

}
