//
//  MainVCViewModelTests.swift
//  QuitTests
//
//  Created by Alex Tudge on 19/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import XCTest
@testable import Quit

class MainVCViewModelTests: XCTestCase {
    
    var sut: MainVCViewModel!
    var quitData: QuitData!
    let formatter = DateFormatter()
    var testDate: Date!
    var changedDate: Date!
    
    override func setUp() {
        super.setUp()
        
        sut = MainVCViewModel(persistenceManager = PersistenceManagerMock())
        
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        testDate = formatter.date(from: "2017/10/08 22:31")!
        changedDate = formatter.date(from: "2016/10/08 22:31")!
        
        //sut.quitData = QuitData(quitData: ["smokedDaily": 10, "costOf20": 10.0, "quitDate": testDate])
    }
    
    override func tearDown() {
        
        sut = nil
        super.tearDown()
    }
    
    func testQuitDateIsInPast() {
        XCTAssertTrue(sut.quitDateIsInPast == true)
        XCTAssertFalse(sut.quitDateIsInPast == false)
    }
    
    func testQuitDateIs3DaysAgoOrMore() {
        XCTAssertTrue(sut.quitDataLongerThan3DaysAgo == true)
        XCTAssertFalse(sut.quitDataLongerThan3DaysAgo == false)
    }
    
    func testConvertQuitDateToString() {
        let altFormatter = DateFormatter()
        altFormatter.dateStyle = .medium
        altFormatter.timeStyle = .none
        let actualStringDate = altFormatter.string(from: testDate)
        let alternativeStringDate = altFormatter.string(from: changedDate)
        XCTAssertTrue(sut.stringQuitDate() == actualStringDate)
        XCTAssertTrue(sut.stringQuitDate() != alternativeStringDate)
    }
    
    func testReturnMediumDateFormatter() {
        let altFormatter = DateFormatter()
        altFormatter.dateStyle = .medium
        altFormatter.timeStyle = .none
        XCTAssertEqual(altFormatter.string(from: testDate), sut.mediumDateFormatter().string(from: testDate))
    }
    
    func testTimeStandardisationOfDates() {
        let comparisonDate = formatter.date(from: "2017/10/08 00:00")
        XCTAssertEqual(comparisonDate, sut.standardisedDate(date: testDate))
    }
    
    func testCurrencyStringCreater() {
        XCTAssertTrue(sut.stringFromCurrencyFormatter(data: 10) == "$10.00")
    }
    
    func testCalculationOfProgressAngleForSavingsCharts() {
        XCTAssertTrue(sut.savingsProgressAngle(goalAmount: 50) == 360.0)
        let savedSoFar = sut.quitData?.savedSoFar
        XCTAssertTrue(sut.savingsProgressAngle(goalAmount: savedSoFar! * 2) <= 200)
    }
}
