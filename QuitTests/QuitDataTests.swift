//
//  QuitDateTests.swift
//  QuitTests
//
//  Created by Alex Tudge on 15/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import XCTest
@testable import Quit

class QuitDateTests: XCTestCase {
    
    var quitDate: QuitData!
    var formatter = DateFormatter()
    var testDate: Date? = nil
    
    override func setUp() {
        super.setUp()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        testDate = formatter.date(from: "2017/10/08 22:31")!
        quitDate = QuitData(quitData: ["smokedDaily": 10 , "costOf20": 10.0, "quitDate": formatter.date(from: "2016/10/08 22:31")!])
        print(quitDate.quitDate)
    }
    
    override func tearDown() {
        quitDate = nil
        super.tearDown()
    }
    
    func testClassInitCorrect() {
        //Test simple class declarations
        XCTAssertTrue(quitDate.smokedDaily == 10)
        XCTAssertFalse(quitDate.smokedDaily == 11)
        XCTAssertTrue(quitDate.costOf20 == 10)
        XCTAssertFalse(quitDate.costOf20 == 11)
        XCTAssertTrue(quitDate.quitDate == formatter.date(from: "2016/10/08 22:31"))
        XCTAssertFalse(quitDate.quitDate == Date())
        XCTAssertFalse(quitDate.quitDate == testDate)
        
        //Test calculated costs
        XCTAssertTrue(quitDate.costPerCigarette == 0.5)
        XCTAssertFalse(quitDate.costPerCigarette == 2)
        XCTAssertTrue(quitDate.costPerDay == 5)
        XCTAssertFalse(quitDate.costPerDay == 20)
        XCTAssertTrue(String(format: "%.5f", arguments: [quitDate.costPerMinute]) == String(format: "%.5f", arguments: [0.00347222222]))
        XCTAssertTrue(quitDate.costPerWeek == 35)
        XCTAssertFalse(quitDate.costPerWeek == 5)
        XCTAssertTrue(quitDate.costPerYear == 1820)
        XCTAssertFalse(quitDate.costPerYear == 1000)
        
        //Logic confirmation
        XCTAssertTrue(quitDate.costPerWeek < quitDate.costPerYear, "It should cost less per a week than a year!")
    }
}
