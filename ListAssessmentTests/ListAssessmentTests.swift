//
//  ListAssessmentTests.swift
//  ListAssessmentTests
//
//  Created by Michael Flowers on 9/27/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import XCTest
@testable import ListAssessment

class ListAssessmentTests: XCTestCase {

    func testSaveToPersistentStore(){
        guard let itemsInPersistentStore = ItemController.shared.fetchedResultsController.fetchedObjects?.count else { return }
        XCTAssert(itemsInPersistentStore > 0, "An item is in the persistent store")
    }

}
