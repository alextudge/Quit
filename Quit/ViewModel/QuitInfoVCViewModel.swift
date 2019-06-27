//
//  QuitInfoVCViewModel.swift
//  Quit
//
//  Created by Alex Tudge on 01/06/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit
import UserNotifications

class QuitInfoVCViewModel {
    func generateLocalNotif(quitDate: Date) {
        Constants.HealthStats.allCases.forEach {
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings { settings in
                guard settings.authorizationStatus == .authorized else {
                    return
                }
            }
            let minutes = 1//Int($0.secondsForHealthState() / 60)
            let content = UNMutableNotificationContent()
            content.categoryIdentifier = Constants.ExternalNotifCategories.healthProgress
            content.title = "New health improvement"
            content.subtitle = $0.rawValue
            content.body = "\(minutes) minutes smoke free!"
            content.sound = UNNotificationSound.default
            let date = Date(timeInterval: TimeInterval(minutes * 60), since: Date())
            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    
    func cancelAppleLocalNotifs() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
}
