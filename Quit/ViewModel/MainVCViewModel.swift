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
    
    private let userDefaults = UserDefaults.standard
    
    private(set) var persistenceManager: PersistenceManagerProtocol!
    private(set) var quitData: QuitData?
    
    var hasSetupOnce = false
    
    init(persistenceManager: PersistenceManagerProtocol = PersistenceManager()) {
        super.init()
        
        self.persistenceManager = persistenceManager
        
        userDefaults.addObserver(self, forKeyPath: "quitData", options: NSKeyValueObservingOptions.new, context: nil)
        
        if let returnedData = userDefaults.object(forKey: "quitData") as? [String: Any] {
            self.quitData = QuitData(quitData: returnedData)
        }
    }
    
    deinit {
        persistenceManager?.saveContext()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        
        if let returnedData = userDefaults.object(forKey: "quitData") as? [String: Any] {
            quitData = QuitData(quitData: returnedData)
        }
    }
    
    var quitDateIsInPast: Bool {
        return quitData!.quitDate < Date()
    }
    
    var quitDataLongerThan6DaysAgo: Bool {
        return Date().timeIntervalSince(quitData!.quitDate) > 518400
    }
    
    func stringQuitDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: quitData!.quitDate)
    }
    
    func mediumDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    func setUserDefaultsQuitDateToCurrent() {
        let quitData: [String: Any] = ["smokedDaily": self.quitData!.smokedDaily, "costOf20": self.quitData!.costOf20, "quitDate": Date()]
        self.userDefaults.set(quitData, forKey: "quitData")
    }
    
    func standardisedDate(date: Date) -> Date {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        let stringDate = formatter.string(from: date)
        return formatter.date(from: stringDate)!
    }
    
    func stringFromCurrencyFormatter(data: NSNumber) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: data)
    }
    
    func countdownLabel() -> String {
        return Date().offsetFrom(date: quitData!.quitDate)
    }
    
    func savingsProgressAngle(goalAmount: Double) -> Double {
        var angle = 0.0
        if self.quitDateIsInPast {
            angle = self.quitData!.savedSoFar / goalAmount * 360
        }
        if angle < 360 {
            return angle
        } else {
            return 360
        }
    }
    
    func cravingButtonAlertTitle() -> String {
        return "Did you smoke?"
    }
    
    func cravingButtonAlertMessage() -> String {
        return "If you smoked, be honest. We'll reset your counter but that doesn't mean the time you've been clean for means nothing. \n\n Add a catagory or trigger below if you want to track them."
    }
    
    func countForSavingPageController() -> Int {
        
        if let count = persistenceManager?.savingsGoals.count {
            return count + 1
        } else {
            return 1
        }
    }
    
    func savingsAttributedText() -> NSAttributedString? {
        
        guard quitData != nil else { return nil }
        var screenOneText = NSAttributedString()
        
        if let formattedDailyCost = stringFromCurrencyFormatter(data: quitData!.costPerDay as NSNumber), let formattedAnnualCost = stringFromCurrencyFormatter(data: quitData!.costPerYear as NSNumber), let formattedSoFarSaving = stringFromCurrencyFormatter(data: quitData!.savedSoFar as NSNumber) {
            
            if quitDateIsInPast {
                screenOneText = NSAttributedString(string: "\(formattedDailyCost) saved daily, \(formattedAnnualCost) saved yearly. \(formattedSoFarSaving) saved so far.", attributes: Constants.savingsInfoAttributes)
            } else {
                screenOneText = NSAttributedString(string: "You're going to save \(formattedDailyCost) daily and \(formattedAnnualCost) yearly.", attributes: Constants.savingsInfoAttributes)
            }
        }
        return screenOneText
    }
    
    func generateProgressView() -> KDCircularProgress {
        let progress = KDCircularProgress()
        progress.startAngle = -90
        progress.isUserInteractionEnabled = true
        progress.progressThickness = 0.6
        progress.trackThickness = 0.6
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = false
        progress.glowMode = .forward
        progress.trackColor = .lightGray
        progress.glowAmount = 0.5
        progress.set(colors: Constants.greenColour)
        return progress
    }
    
    func appStoreReview() {
        
        //Ask for a store review after a few days of quitting
        if quitDataLongerThan6DaysAgo {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            }
        }
    }
    
    func requestNotifAuth() {
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in }
    }
}
