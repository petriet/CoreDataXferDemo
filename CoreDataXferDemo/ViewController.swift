//
//  ViewController.swift
//  CoreDataXferDemo
//
//  Created by Tracy Petrie on 7/18/17.
//  Copyright © 2017 Tracy Petrie. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var managedContext: NSManagedObjectContext!

    @IBAction func onReset(_ sender: Any) {
        NewStack.emptyNewModel()
        OldStack.emptyOldModel()
        OldStack.populateOldModel()
    }
    
    @IBAction func onShowOldModel(_ sender: Any) {
        OldStack.showOldModel()
    }
    
    
    @IBAction func onTransfer(_ sender: Any) {
        print("onTransfer")
        let oldContext: NSManagedObjectContext = OldStackFactory.createOldStack().managedContext
        let newContext: NSManagedObjectContext = NewStackFactory.createNewStack().managedContext
        
        
        let libraryFetch: NSFetchRequest<Library> = Library.fetchRequest()
        let patronFetch: NSFetchRequest<Patron> = Patron.fetchRequest()
        let bookFetch: NSFetchRequest<Book> = Book.fetchRequest()
        
        // Create temporary dictionaries indexed by GUID (or "patronCard") of new objects for conversion
        var library2Objects: [String:Library2] = [:]
        var patron2Objects: [String:Patron2] = [:]
        var book2Objects: [String:Book2] = [:]
        var libraryToLibrary2Map: [Int64:String] = [:]
        var patronToPatron2Map: [Int64:String] = [:]
        var bookToBook2Map: [Int64:String] = [:]
        
        // Create a simple generic function rather than heavy-weight class functions
        func getObjectByID<T> (searchKey:String, objList:[String:T]) -> T? {
            var returnObj: T? = nil
            for (key, item) in objList {
                if searchKey == key {
                    returnObj = item
                }
            }
            return returnObj
        }
        
        // Create libraries first...
        do {
            let results = try oldContext.fetch(libraryFetch)
            for library in results {
                let uuid = NSUUID().uuidString
                let newLibrary = Library2(context: newContext)
                newLibrary.libraryUUID = uuid
                newLibrary.libraryName = library.libraryName
                libraryToLibrary2Map[library.libraryID] = uuid
                library2Objects[uuid] = newLibrary
            }
        } catch {
            print("Error getting library objects")
        }
        
        // Create patrons ...
        do {
            let results = try oldContext.fetch(patronFetch)
            for patron in results {
                let uuid = NSUUID().uuidString
                let newPatron = Patron2(context: newContext)
                newPatron.partronCard = uuid        // could, for example, convert Int to String as well
                newPatron.name = patron.name
                patronToPatron2Map[patron.libraryCard] = uuid
                patron2Objects[uuid] = newPatron
            }
        } catch {
            print("Error getting patron objects")
        }
        
        // Create books and loans at the same time
        // TODO: parameterized fetches to grab patron and library
        do {
            let results = try oldContext.fetch(bookFetch)
            for book in results {
                let uuid = NSUUID().uuidString
                let newBook = Book2(context: newContext)
                newBook.bookUUID = uuid        // could, for example, convert Int to String as well
                newBook.title = book.title
                newBook.totalAvailable = Int16(Int(arc4random_uniform(UInt32(10))) + Int(10))
                newBook.currentlyAvailable = newBook.totalAvailable
                if let borrowers = book.borrowedBy?.count {
                    newBook.currentlyAvailable -= Int16(borrowers)
                    if borrowers > 0 {
                        for case let oldPatron as Patron in book.borrowedBy! {  // Thank you Stackoverflow!!!
                            let newLoan = Loan2(context: newContext)
                            // convert patron ID to patron UUID
                            let partronUUID = patronToPatron2Map[oldPatron.libraryCard]
                            newLoan.lentTo = patron2Objects[partronUUID!]
                            newLoan.lentBook = newBook
                            // TODO : some clever due date stuff only, nah
                        }
                    }
                }
                bookToBook2Map[book.bookID] = uuid
                book2Objects[uuid] = newBook
            }
        } catch {
            print("Error getting patron objects")
        }
       
        do {
            try newContext.save()
        } catch let err as NSError {
            print("Error saving new data: \(err)")
        }

    }
    
    @IBAction func onShowNewModel(_ sender: Any) {
        NewStack.showNewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

