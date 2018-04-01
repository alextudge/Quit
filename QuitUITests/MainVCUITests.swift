//
//  QuitUITests.swift
//  QuitUITests
//
//  Created by Alex Tudge on 15/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import XCTest

class QuitUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testChangingQuitDate() {
//        let app = XCUIApplication()
//        app.children(matching: .other).element(boundBy: 0).children(matching: .other).element(boundBy: 1).tap()
//        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Oct 8, 2016"]/*[[".cells.staticTexts[\"Oct 8, 2016\"]",".staticTexts[\"Oct 8, 2016\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        app.datePickers.pickerWheels["Sat, Oct 8"].swipeDown()
//        app.buttons["Save"].tap()
//    }
}
