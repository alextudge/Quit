//
//  AddCravingVCViewModel.swift
//  Quit
//
//  Created by Alex Tudge on 15/11/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import Foundation
import StoreKit

class AddCravingViewModel {
    
    private var persistenceManager: PersistenceManager?
    
    init(persistenceManager: PersistenceManager?) {
        self.persistenceManager = persistenceManager
    }
    
    func appStoreReview() {
        guard let profile = persistenceManager?.getProfile() else {
            return
        }
        if profileLongerThan4DaysAgo(profile: profile) {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            }
        }
    }
    
    func quitDateIsInPast() -> Bool {
        guard let quitDate = persistenceManager?.getProfile()?.quitDate else {
            return false
        }
        return quitDate < Date()
    }
    
    private func profileLongerThan4DaysAgo(profile: Profile?) -> Bool {
        guard let quitDate = profile?.quitDate else {
            return false
        }
        let sixDaysInSeconds = Double(345600)
        return Date().timeIntervalSince(quitDate) > sixDaysInSeconds
    }
}
