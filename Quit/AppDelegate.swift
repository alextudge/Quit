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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let healthNotificationCategory = UNNotificationCategory(identifier: "healthNotificationCategory", actions: [], intentIdentifiers: [], options: [])
    UNUserNotificationCenter.current().setNotificationCategories([healthNotificationCategory])
        return true
    }
}
