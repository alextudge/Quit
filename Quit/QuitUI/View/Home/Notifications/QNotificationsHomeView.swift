//
//  QNotificationsHomeView.swift
//  Quit
//
//  Created by Alex Tudge on 13/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QNotificationsHomeView: View {
    var body: some View {
        List {
            NavigationLink(destination: QAddCustomNotificationView()) {
                Text("Add a custom notification")
            }
            NavigationLink(destination: QViewPendingNotificationsView()) {
                Text("View all upcoming notifications")
            }
        }
    }
}

struct QNotificationsHomeView_Previews: PreviewProvider {
    static var previews: some View {
        QNotificationsHomeView()
    }
}
