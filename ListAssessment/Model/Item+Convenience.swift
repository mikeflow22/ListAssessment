//
//  Item+Convenience.swift
//  ListAssessment
//
//  Created by Michael Flowers on 9/27/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import Foundation
import CoreData

extension Item {
    
    convenience init(name: String, isComplete: Bool = false, context: NSManagedObjectContext = CoreDataStack.mainContext){
        self.init(context: context)
        self.name = name
    }
}
