//
//  AppDelegate.swift
//  Quit
//
//  Created by Alex Tudge on 02/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GADMobileAds.configure(withApplicationID: "ca-app-pub-9559625170509646~1544442423")
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                let healthNotificationCategory = UNNotificationCategory(identifier: Constants.ExternalNotifCategories.healthProgress, actions: [], intentIdentifiers: [], options: [])
                UNUserNotificationCenter.current().setNotificationCategories([healthNotificationCategory])
            } else {
                return
            }
        }
        return true
    }
}
