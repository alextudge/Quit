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
        
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        testDate = formatter.date(from: "2017/10/08 22:31")!
        changedDate = formatter.date(from: "2016/10/08 22:31")!
        
        quitData = QuitData(quitData: ["smokedDaily": 10, "costOf20": 10.0, "quitDate": testDate])
        sut = MainVCViewModel(persistenceManager: PersistenceManagerMock())
        sut.quitData = quitData
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut = nil
        quitData = nil
    }
    
    func testQuitDateIsInPast() {
        
        XCTAssertTrue(sut.quitDateIsInPast == true)
        XCTAssertFalse(sut.quitDateIsInPast == false)
    }
    
    func testQuitDateIs6DaysAgoOrMore() {
        
        XCTAssertTrue(sut.quitDataLongerThan6DaysAgo == true)
        XCTAssertFalse(sut.quitDataLongerThan6DaysAgo == false)
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
    
    func testCravingAlertTitle() {
        XCTAssertEqual("Did you smoke?", sut.cravingButtonAlertTitle())
    }
    
    func testCravingAlertMessage() {
        
        XCTAssertEqual("them.",
                       sut.cravingButtonAlertMessage())
    }
    
    func testCountForSavingsPageController() {
        
        XCTAssert(sut.countForSavingPageController() == 1)

        //TODO adding savings
    }
    
    func testSavingsAttributedTestGenerator() {
        
        let generatedText = sut.savingsAttributedText()
        
        //As we know the quit date is set to more than 6 days ago, test that the generated string reflects this
        XCTAssertTrue((generatedText?.string.contains("saved daily"))!)
        XCTAssertFalse((generatedText?.string.contains("You're"))!)
    }
}
