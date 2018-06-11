//
//  MainVCViewModel
//  Quit
//
//  Created by Alex Tudge on 18/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import Foundation
import StoreKit
import UserNotifications

class MainVCViewModel: NSObject {
    
    private(set) var persistenceManager: PersistenceManagerProtocol!
    private(set) var chartFactory: ChartFactory?
    
    init(persistenceManager: PersistenceManagerProtocol = PersistenceManager()) {
        super.init()
        
        self.persistenceManager = persistenceManager
        self.chartFactory = ChartFactory()
    }
    
    deinit {
        persistenceManager?.saveContext()
        persistenceManager = nil
        chartFactory = nil
    }
    
    //Time related functions
    
    func quitDateIsInPast(quitData: QuitData?) -> Bool {
        
        guard let quitDate = quitData?.quitDate else { return false }
        return quitDate < Date()
    }
    
    func quitDataLongerThan4DaysAgo(quitData: QuitData?) -> Bool {
        
        //Time intervals are processed in seconds
        
        guard let quitDate = quitData?.quitDate else { return false }
        let sixDaysInSeconds = Double(345600)
        return Date().timeIntervalSince(quitDate) > sixDaysInSeconds
    }
    
    //Date formatters
    
    func stringQuitDate(quitData: QuitData?) -> String? {
        
        guard let quitDate = quitData?.quitDate else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: quitDate)
    }
    
    func mediumDateFormatter() -> DateFormatter {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    func standardisedDate(date: Date) -> Date {
        
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        let stringDate = formatter.string(from: date)
        return formatter.date(from: stringDate)!
    }
    
    //Model manipulation
    
    func setUserDefaultsQuitDateToCurrent(quitData: QuitData?) {
        
        guard quitData != nil else { return }
        let quitData: [String: Any] = ["smokedDaily": quitData!.smokedDaily as Any,
                                       "costOf20": quitData!.costOf20 as Any,
                                       "quitDate": Date()]
        persistenceManager?.setQuitDataInUserDefaults(object: quitData, key: "quitData")
    }
    
    //General formatters
    
    func stringFromCurrencyFormatter(data: NSNumber) -> String? {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: data)
    }
    
    func countdownLabel(quitData: QuitData?) -> String? {
        
        guard let quitDate = quitData?.quitDate else { return nil }
        return Date().offsetFrom(date: quitDate)
    }
    
    func cravingButtonAlertTitle() -> String {
        return "Did you smoke?"
    }
    
    func cravingButtonAlertMessage() -> String {
        
        let honesty = "Be honest!\n"
        let resetNotif = "We'll reset the quit date but your work so far still counts.\n\n"
        let triggers = "Add a trigger below to track them."
        return honesty + resetNotif + triggers
    }
    
    func savingsAttributedText(quitData: QuitData?) -> NSAttributedString? {
        
        guard let costPerDay = quitData?.costPerDay as NSNumber?,
            let costPerYear = quitData?.costPerYear as NSNumber?,
            let savedSoFar = quitData?.savedSoFar as NSNumber? else { return nil }
        
        //Format the costs with local currencies
        
        var text = NSAttributedString()
        if let dailyCost = stringFromCurrencyFormatter(data: costPerDay),
            let annualCost = stringFromCurrencyFormatter(data: costPerYear),
            let soFar = stringFromCurrencyFormatter(data: savedSoFar) {
            
            if quitDateIsInPast(quitData: quitData) {
                text = NSAttributedString(
                    string: "\(dailyCost) saved daily, \(annualCost) saved yearly. \(soFar) saved so far.",
                    attributes: Constants.savingsInfoAttributes)
            } else {
                text = NSAttributedString(string: "You'll save \(dailyCost) daily and \(annualCost) yearly.",
                    attributes: Constants.savingsInfoAttributes)
            }
        }
        return text
    }
    
    //General functions
    
    func savingsProgressAngle(goalAmount: Double, quitData: QuitData?) -> Double? {
        
        guard let quitSavingsToDate = quitData?.savedSoFar else { return nil }
        
        var angle = 0.0
        if self.quitDateIsInPast(quitData: quitData) {
            angle = quitSavingsToDate / goalAmount * 360
        }
        if angle < 360 {
            return angle
        } else {
            return 360
        }
    }
    
    func countForSavingPageController() -> Int {
        
        if let count = persistenceManager?.savingsGoals.count {
            return count + 1
        } else {
            return 1
        }
    }
    
    func processCravingData() -> ([Date: Int], [Date: Int], [String: Int]) {
        
        //THIS NEEDS CLEANING UP/SIMPLIFYING
        var cravingTriggerDictionary = [String: Int]()
        var cravingDateDictionary = [Date: Int]()
        var smokedDateDictionary = [Date: Int]()
        
        for craving in persistenceManager.cravings {
            if let cravingCatagory = craving.cravingCatagory {
                cravingTriggerDictionary[cravingCatagory] = (cravingTriggerDictionary[cravingCatagory] == nil) ? 1 :
                    cravingTriggerDictionary[cravingCatagory]! + 1
            }
            if let cravingDate = craving.cravingDate {
                let standardisedDate = self.standardisedDate(date: cravingDate)
                if craving.cravingSmoked == true {
                    smokedDateDictionary[standardisedDate] = (smokedDateDictionary[standardisedDate] == nil) ? 1 :
                        smokedDateDictionary[standardisedDate]! + 1
                } else {
                    cravingDateDictionary[standardisedDate] = (cravingDateDictionary[standardisedDate] == nil) ? 1 :
                        cravingDateDictionary[standardisedDate]! + 1
                }
            }
        }
        return (cravingDateDictionary, smokedDateDictionary, cravingTriggerDictionary)
    }
    
    func appStoreReview(quitData: QuitData?) {
        
        guard quitData != nil else { return }
        
        //Ask for a store review after a few days of quitting
        
        if quitDataLongerThan4DaysAgo(quitData: quitData) {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            }
        }
    }
    
    func requestNotifAuth() {
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (_, _) in }
    }
}
