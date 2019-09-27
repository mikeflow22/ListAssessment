//
//  ItemController.swift
//  ListAssessment
//
//  Created by Michael Flowers on 9/27/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import Foundation
import CoreData

class ItemController {
    
    static let shared = ItemController()
    var fetchedResultsController: NSFetchedResultsController<Item>
    init(){
        //create your fetchResultsController here
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let isCompleteSort = NSSortDescriptor(key: "isComplete", ascending: true)
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [isCompleteSort, nameSort]
        let resultsFetched  = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.mainContext, sectionNameKeyPath: "isComplete", cacheName: nil)
        
        do {
            try resultsFetched.performFetch()
        } catch  {
            print("Error  trying to fetch results: \(error)")
        }
        
        fetchedResultsController =  resultsFetched
    }
    
    func createItem(name: String) {
        _ = Item(name: name)
        saveToPersistentStore()
    }
    
    func delete(item: Item){
        CoreDataStack.mainContext.delete(item)
        saveToPersistentStore()
    }
    
    func update(item: Item, withName name: String){
        item.name = name
        saveToPersistentStore()
    }
    
     func toggleItem(_ item: Item){
        item.isComplete = !item.isComplete
        saveToPersistentStore()
    }
    
    func saveToPersistentStore(){
        do {
            try CoreDataStack.mainContext.save()
        } catch  {
            print("Error saving to persistent store: \(error) in \(#function)")
        }
    }
    
}
