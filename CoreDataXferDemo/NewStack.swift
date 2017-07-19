//
//  NewStack.swift
//  CoreDataXferDemo
//
//  Created by Tracy Petrie on 7/18/17.
//  Copyright © 2017 Tracy Petrie. All rights reserved.
//

import Foundation
import CoreData

class NewStackFactory {
    private static var newStack: NewStack?
    
    class func createNewStack() -> NewStack {
        if newStack == nil {
            newStack = NewStack(modelName: "NewLibraryModel")
        }
        return newStack!
    }
}

class NewStack {
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
    
    class func emptyNewModel() {
        let managedContext = NewStackFactory.createNewStack().managedContext
        
        let libraryFetch: NSFetchRequest<Library2> = Library2.fetchRequest()
        let patronFetch: NSFetchRequest<Patron2> = Patron2.fetchRequest()
        let bookFetch: NSFetchRequest<Book2> = Book2.fetchRequest()
        let loanFetch: NSFetchRequest<Loan2> = Loan2.fetchRequest()

        
        // Delete loans first...
        do {
            let results = try managedContext.fetch(loanFetch)
            for loan in results {
                managedContext.delete(loan)
            }
        } catch {
            print("Error getting patron objects")
        }

        // Delete books next...
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
            print("Error saving new data deletes: \(err)")
        }
        
    }
    
    /**
     Class method to show the current state of the Old Model
     
     */
    class func showNewModel() {
        print("onShowNewModel")
        let libraryFetch: NSFetchRequest<Library2> = Library2.fetchRequest()
        let patronFetch: NSFetchRequest<Patron2> = Patron2.fetchRequest()
        let bookFetch: NSFetchRequest<Book2> = Book2.fetchRequest()
        let loanFetch: NSFetchRequest<Loan2> = Loan2.fetchRequest()
        
        // Show libraries first...
        let managedContext = NewStackFactory.createNewStack().managedContext
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
        do {
            let results = try managedContext.fetch(bookFetch)
            for book in results {
                print("Book: \(book.title!)")
            }
        } catch {
            print("Error getting book objects")
        }

        // Show loans
        do {
            let results = try managedContext.fetch(loanFetch)
            for loan in results {
                print("Book: \(loan.lentBook?.title) is lent to \(loan.lentTo?.name)")
            }
        } catch {
            print("Error getting loan objects")
        }
    }
    
}
