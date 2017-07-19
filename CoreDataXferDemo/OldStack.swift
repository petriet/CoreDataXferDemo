//
//  OldStack.swift
//  CoreDataXferDemo
//
//  Created by Tracy Petrie on 7/18/17.
//  Copyright © 2017 Tracy Petrie. All rights reserved.
//

import Foundation
import CoreData

class OldStackFactory {
    private static var oldStack: OldStack?
    
    class func createOldStack() -> OldStack {
        if oldStack == nil {
            oldStack = OldStack(modelName: "CoreDataXferDemo")
        }
        return oldStack!
    }
}

class OldStack {
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores {
            (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()

    func saveContext () {
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /**
     Class method to populate Old Model with data to migrate
     
     */
    class func populateOldModel() {
        let managedContext = OldStackFactory.createOldStack().managedContext
        
        let libraryNames = ["Washington", "Lincoln", "Main"]
        let patronNames = ["John", "Sue", "Mark", "Karen"]
        let bookNames = ["The Hobbit", "A Wizard of Earthsea", "A Brief History of Time", "The Cell", "Functional Programming for Dummies", "Git for Teams", "Deep Learning", "The Illiad", "Animal Farm", "I Robot", "Dune", "Computational Science", "Discrete Mathematics", "Innumeracy", "The Tiger that Wasn't", "The Man Who Knew Infinity", "The Man Who Loved Only Numbers", "The Imitation Game", "A Beautiful Mind", "McCarthy's Bar", "Europe Through the Back Door", "The Abolition of Man"]
        
        var libraryObjects: [Library] = []
        var patronObjects: [Patron] = []
        var bookObjects: [Book] = []
        var nextID: Int64 = 0
        
        let getNextID: () -> Int64 = {
            nextID += 1
            return nextID
        }
        
        // Create Libraries
        for name in libraryNames {
            let newLibrary = Library(context: managedContext)
            newLibrary.libraryName = name
            newLibrary.libraryID = getNextID()
            libraryObjects.append(newLibrary)
        }
        
        // Create Patrons
        for name in patronNames {
            let newPatron = Patron(context: managedContext)
            newPatron.name = name
            newPatron.libraryCard = getNextID()
            patronObjects.append(newPatron)
        }
        
        // Create Books
        for name in bookNames {
            let newBook = Book(context: managedContext)
            newBook.title = name
            newBook.bookID = getNextID()
            var randomNum:Int = Int(arc4random_uniform(UInt32(libraryObjects.count)))
            newBook.belongsTo = libraryObjects[randomNum]
            randomNum = Int(arc4random_uniform(UInt32(patronObjects.count)))
            newBook.addToBorrowedBy(patronObjects[randomNum])
            bookObjects.append(newBook)
        }
        
        do {
            try managedContext.save()
        } catch let err as NSError {
            print("Error saving old data: \(err)")
        }
    }
    
    /**
     Class method to remove all the data in the Old Model
     
     This is one way to do it (batch updates) but is more likely to cause problems (keeping in synch with memory objects, etc.)
     See: https://developer.apple.com/library/content/featuredarticles/CoreData_Batch_Guide/BatchDeletes/BatchDeletes.html
     do {
     let delAllPatrons = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName:"Patron"))
     try managedContext.execute(delAllPatrons)
     } catch let err as NSError {
     fatalError("Unresolved error \(err), \(err.userInfo)")
     }
 
    */
    class func emptyOldModel() {
        let managedContext = OldStackFactory.createOldStack().managedContext

        let libraryFetch: NSFetchRequest<Library> = Library.fetchRequest()
        let patronFetch: NSFetchRequest<Patron> = Patron.fetchRequest()
        let bookFetch: NSFetchRequest<Book> = Book.fetchRequest()
        
        // Delete books first...
        do {
            let results = try managedContext.fetch(bookFetch)
            for book in results {
                managedContext.delete(book)
            }
        } catch {
            print("Error getting patron objects")
        }
        // Delete libraries
        do {
            let results = try managedContext.fetch(libraryFetch)
            for library in results {
                managedContext.delete(library)
            }
        } catch {
            print("Error getting library objects")
        }
        
        // Delete patrons ...
        do {
            let results = try managedContext.fetch(patronFetch)
            for patron in results {
                managedContext.delete(patron)
            }
        } catch {
            print("Error getting patron objects")
        }
        
        
        do {
            try managedContext.save()
        } catch let err as NSError {
            print("Error saving old data: \(err)")
        }

    }
    
    /**
     Class method to show the current state of the Old Model
     
    */
    class func showOldModel() {
        print("onShowOldModel")
        let libraryFetch: NSFetchRequest<Library> = Library.fetchRequest()
        let patronFetch: NSFetchRequest<Patron> = Patron.fetchRequest()
        let bookFetch: NSFetchRequest<Book> = Book.fetchRequest()
        
        // Show libraries first...
        let managedContext = OldStackFactory.createOldStack().managedContext
        do {
            let results = try managedContext.fetch(libraryFetch)
            for library in results {
                print("Library: \(library.libraryName!)")
            }
        } catch {
            print("Error getting library objects")
        }
        
        // Show patrons ...
        do {
            let results = try managedContext.fetch(patronFetch)
            for patron in results {
                print("Patron: \(patron.name!)")
            }
        } catch {
            print("Error getting patron objects")
        }
        
        // Show books
        // TODO: parameterized fetches to grab patron and library
        do {
            let results = try managedContext.fetch(bookFetch)
            for book in results {
                print("Book: \(book.title!)")
                if let borrowers = book.borrowedBy?.count {
                    if borrowers > 0 {
                        for case let oldPatron as Patron in book.borrowedBy! {  // Thank you Stackoverflow!!!
                            print("    borrowed by \(oldPatron.name)")
                        }
                    }
                }
            }
        } catch {
            print("Error getting patron objects")
        }
    }
    
}
