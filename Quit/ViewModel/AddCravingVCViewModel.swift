//
//  AddCravingVCViewModel.swift
//  Quit
//
//  Created by Alex Tudge on 15/11/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import Foundation
import StoreKit

class AddCravingVCViewModel {
    
    var persistenceManager: PersistenceManager?
    
    func appStoreReview() {
        guard let quitData = persistenceManager?.quitData else {
            return
        }
        if quitDataLongerThan4DaysAgo(quitData: quitData) {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            }
        }
    }
    
    func quitDateIsInPast() -> Bool {
        guard let quitDate = persistenceManager?.quitData?.quitDate else {
            return false
        }
        return quitDate < Date()
    }
    
    private func quitDataLongerThan4DaysAgo(quitData: QuitData?) -> Bool {
        guard let quitDate = quitData?.quitDate else {
            return false
        }
        let sixDaysInSeconds = Double(345600)
        return Date().timeIntervalSince(quitDate) > sixDaysInSeconds
    }
    
    func setUserDefaultsQuitDateToCurrent() {
        guard let quitData = persistenceManager?.quitData else {
            return
        }
        let actualQuitData: [String: Any] = ["smokedDaily": quitData.smokedDaily as Any,
                                       "costOf20": quitData.costOf20 as Any,
                                       "quitDate": Date()]
        persistenceManager?.setQuitDataInUserDefaults(object: actualQuitData, key: "quitData")
    }
}
