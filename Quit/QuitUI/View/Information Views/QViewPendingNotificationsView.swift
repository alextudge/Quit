//
//  QViewPendingNotificationsView.swift
//  Quit
//
//  Created by Alex Tudge on 13/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI
import UserNotifications

struct QViewPendingNotificationsView: View {
    
    @State private var notifications = [UNNotificationRequest]()
    private let center = UNUserNotificationCenter.current()
    
    var body: some View {
        List {
            ForEach(notifications, id: \.self) { notification in
                VStack {
                    Text(notification.content.title)
                    Text(notification.content.body)
                    if let triggerDate = (notification.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate() {
                        Text("\(triggerDate)")
                    }
                }
            }
        }
        .navigationTitle("Upcoming notifications")
        .onAppear {
            getAllPendingNotifications()
        }
    }
}

private extension QViewPendingNotificationsView {
    func getAllPendingNotifications() {
        center.getPendingNotificationRequests(completionHandler: { requests in
            requests.forEach {
                self.notifications.append($0)
            }
        })
    }
}

struct QViewPendingNotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        QViewPendingNotificationsView()
    }
}
