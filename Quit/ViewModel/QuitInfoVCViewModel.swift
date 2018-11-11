//
//  QuitInfoVCViewModel.swift
//  Quit
//
//  Created by Alex Tudge on 01/06/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import Foundation
import UserNotifications

class QuitInfoVCViewModel {
    
    func generateLocalNotif(title: String, body: String, minutes: Double, datePicker: Date) {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = UNNotificationSound.default
            let date = Date(timeInterval: TimeInterval(minutes * 60), since: datePicker)
            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                              from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
    }
    
    func cancelAppleLocalNotifs() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
}
