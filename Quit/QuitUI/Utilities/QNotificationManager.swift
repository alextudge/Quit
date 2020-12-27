//
//  QNotificationManager.swift
//  Quit
//
//  Created by Alex Tudge on 19/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import UserNotifications

class QNotificationManager {
    
    enum NotificationType: String, CaseIterable {
        case health
    }
    
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in }
    }
    
    func cancelAllAutomaticNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: NotificationType.allCases.compactMap { $0.rawValue })
    }
    
    func cancelNotification(with identifier: String) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func setupHealthNotifications(quitDate: Date) {
        QHealth.allCases.forEach {
            let minutes = Int($0.secondsForHealthState()) / 60
            let triggerDate = Date(timeInterval: TimeInterval($0.secondsForHealthState()), since: quitDate)
            setTimeNotification(title: $0.title, message: "\(minutes) minutes smoke free!", date: triggerDate)
        }
    }
}

private extension QNotificationManager {
    func setTimeNotification(title: String, message: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = message
        content.sound = .default
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: title, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
