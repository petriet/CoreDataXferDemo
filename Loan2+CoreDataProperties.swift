//
//  Loan2+CoreDataProperties.swift
//  CoreDataXferDemo
//
//  Created by Tracy Petrie on 7/18/17.
//  Copyright © 2017 Tracy Petrie. All rights reserved.
//

import Foundation
import CoreData


extension Loan2 {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Loan2> {
        return NSFetchRequest<Loan2>(entityName: "Loan2")
    }

    @NSManaged public var checkoutDate: NSDate?
    @NSManaged public var dueDate: NSDate?
    @NSManaged public var lentTo: Patron2?
    @NSManaged public var lentBook: Book2?

}
