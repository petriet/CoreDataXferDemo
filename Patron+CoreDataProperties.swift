//
//  Patron+CoreDataProperties.swift
//  CoreDataXferDemo
//
//  Created by Tracy Petrie on 7/18/17.
//  Copyright © 2017 Tracy Petrie. All rights reserved.
//

import Foundation
import CoreData


extension Patron {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Patron> {
        return NSFetchRequest<Patron>(entityName: "Patron")
    }

    @NSManaged public var name: String?
    @NSManaged public var libraryCard: Int64
    @NSManaged public var borrows: Book?

}
