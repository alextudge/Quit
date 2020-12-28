//
//  QNotificationsHomeView.swift
//  Quit
//
//  Created by Alex Tudge on 13/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QNotificationsHomeView: View {
    
    @ObservedObject var profile: Profile
    
    var body: some View {
        List {
            NavigationLink(destination: QAddCustomNotificationView(profile: profile)) {
                Text("Add a custom notification")
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
