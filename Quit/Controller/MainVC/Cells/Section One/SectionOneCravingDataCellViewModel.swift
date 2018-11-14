//
//  SectionOneCravingDataCellViewModel.swift
//  Quit
//
//  Created by Alex Tudge on 04/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import Foundation
import StoreKit

class SectionOneCravingDataCellViewModel {
    
    var persistenceManager: PersistenceManager!
    
    func stringQuitDate(quitData: QuitData?) -> String? {
        guard let quitDate = quitData?.quitDate else {
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: quitDate)
    }
    
    func countdownLabel(quitData: QuitData?) -> String? {
        guard let quitDate = quitData?.quitDate else {
            return nil
        }
        return Date().offsetFrom(date: quitDate)
    }
    
    func cravingButtonAlertTitle() -> String {
        return "Did you smoke?"
    }
    
    func cravingButtonAlertMessage() -> String {
        let honesty = "Be honest!\n"
        let triggers = "Add a trigger below to track them."
        return honesty + triggers
    }
    
    func quitDateIsInPast(quitData: QuitData?) -> Bool {
        guard let quitDate = quitData?.quitDate else {
            return false
        }
        return quitDate < Date()
    }
    
    func quitDataLongerThan4DaysAgo(quitData: QuitData?) -> Bool {
        guard let quitDate = quitData?.quitDate else {
            return false
        }
        let sixDaysInSeconds = Double(345600)
        return Date().timeIntervalSince(quitDate) > sixDaysInSeconds
    }
    
    func setUserDefaultsQuitDateToCurrent(quitData: QuitData?) {
        guard quitData != nil else {
            return
        }
        let quitData: [String: Any] = ["smokedDaily": quitData!.smokedDaily as Any,
                                       "costOf20": quitData!.costOf20 as Any,
                                       "quitDate": Date()]
        persistenceManager.setQuitDataInUserDefaults(object: quitData, key: "quitData")
    }
    
    func appStoreReview(quitData: QuitData?) {
        guard quitData != nil else {
            return
        }        
        if quitDataLongerThan4DaysAgo(quitData: quitData) {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            }
        }
    }
}
