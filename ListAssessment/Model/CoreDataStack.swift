//
//  CoreDataStack.swift
//  ListAssessment
//
//  Created by Michael Flowers on 9/27/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import Foundation
//step 1
import CoreData

class CoreDataStack {
    //step 2: create a container to hold the stack
    static let container: NSPersistentContainer = {
        //create this container to be run later, when someone asks for it instead of immediately
        let container = NSPersistentContainer(name: "List")
        //step 3 tell the container what to do
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //step 4 create the context (MOC)
    static var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}

