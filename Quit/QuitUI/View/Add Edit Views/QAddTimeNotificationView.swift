//
//  QAddTimeNotificationView.swift
//  Quit
//
//  Created by Alex Tudge on 13/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI
import UserNotifications

struct QAddTimeNotificationView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var selectedDate = Date()
    @State private var title = ""
    @State private var message = ""
    
    var body: some View {
        Form {
            DatePicker("Please enter a time", selection: $selectedDate, displayedComponents: .hourAndMinute)
            TextField("Give your notification a title", text: $title)
            TextField("Give your notification a message", text: $message)
            Button("Save", action: {
                setTimeNotification()
            })
            .buttonStyle(QButtonStyle())
        }
    }
}

private extension QAddTimeNotificationView {
    func setTimeNotification() {
        let components = Calendar.current.dateComponents([.hour, .minute], from: selectedDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        let timeNotification = UNNotificationRequest(identifier: "\(components)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(timeNotification) { _ in
            DispatchQueue.main.async {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct QAddTimeNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        QAddTimeNotificationView()
    }
}