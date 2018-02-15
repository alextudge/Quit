//
//  QuitSavingGoalVCTests.swift
//  QuitTests
//
//  Created by Alex Tudge on 15/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import XCTest
@testable import Quit

class QuitSavingGoalVCTests: XCTestCase {
    
    var VC: UIViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "main", bundle: Bundle.main)
        VC = storyboard.instantiateInitialViewController() as! UIViewController
    }
    
    override func tearDown() {
        VC = nil
        super.tearDown()
    }
    
    func testButtons() {
        
    }
}
