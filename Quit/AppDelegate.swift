//
//  AppDelegate.swift
//  Quit
//
//  Created by Alex Tudge on 02/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit
import UserNotifications
import GoogleMobileAds
import SwiftyStoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        configureNotifications()
        configurePurchases()
        return true
    }
}

private extension AppDelegate {
    func configureNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            if granted {
                let healthNotificationCategory = UNNotificationCategory(identifier: Constants.ExternalNotifCategories.healthProgress, actions: [], intentIdentifiers: [], options: [])
                UNUserNotificationCenter.current().setNotificationCategories([healthNotificationCategory])
            }
        }
    }
    
    func configurePurchases() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
        }
    }
}
