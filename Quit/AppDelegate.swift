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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GADMobileAds.configure(withApplicationID: Constants.AppConfig.adAppId)
        configureNotifications()
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
}
