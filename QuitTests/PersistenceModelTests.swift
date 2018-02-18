//
//  PersistenceModelTests.swift
//  QuitTests
//
//  Created by Alex Tudge on 17/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import XCTest
import CoreData
@testable import Quit

class PersistenceModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSomethingUsingCoreData() {
        let managedObjectContext = setUpInMemoryManagedObjectContext()
        let craving = Craving(context: managedObjectContext)
        craving.cravingCatagory = "Test"
        craving.cravingSmoked = true
        craving.cravingDate = Date()
        
        // model setup
        
        // XCTAssert
        
    }
}
