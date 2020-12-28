//
//  QNotificationsHomeView.swift
//  Quit
//
//  Created by Alex Tudge on 13/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QNotificationsHomeView: View {
    
    private let center = UNUserNotificationCenter.current()
    @State private var hasCustomNotifications = false
    @ObservedObject var profile: Profile
    
    var body: some View {
        List {
            if profile.isPro {
                NavigationLink(destination: QAddCustomNotificationView(profile: profile)) {
                    Text("Add a custom notification")
                }
            } else {
                NavigationLink(destination: QPurchaseProView(profile: profile)) {
                    Text("Go pro to add custom notifications based on a time or a location.")
                }
            }
            NavigationLink(destination: QViewPendingNotificationsView()) {
                Text("View all upcoming notifications")
            }
        }
        .navigationTitle("Notifications")
    }
}

struct QNotificationsHomeView_Previews: PreviewProvider {
    static var previews: some View {
        QNotificationsHomeView(profile: Profile())
    }
}
