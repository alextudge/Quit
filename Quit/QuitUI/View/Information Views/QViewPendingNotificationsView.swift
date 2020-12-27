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
        Text("You can cancel specific notifications using the edit button.")
            .padding()
            .foregroundColor(Color.secondary)
        List {
            ForEach(notifications, id: \.self) { notification in
                VStack(alignment: .leading) {
                    Text(notification.content.title)
                        .font(.title2)
                    Text(notification.content.body)
                        .font(.caption)
                    if let triggerDate = (notification.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate() {
                        Text("Next due: \(triggerDate)")
                            .font(.caption)
                    }
                }
            }
            .onDelete(perform: delete)
        }
        .navigationTitle("Upcoming notifications")
        .navigationBarItems(trailing: EditButton())
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
    
    func delete(at offsets: IndexSet) {
        offsets.forEach {
            QNotificationManager().cancelNotification(with: notifications[$0].identifier)
        }
    }
}

struct QViewPendingNotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        QViewPendingNotificationsView()
    }
}
