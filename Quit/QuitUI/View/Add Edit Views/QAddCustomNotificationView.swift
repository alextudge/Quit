//
//  QAddCustomNotificationView.swift
//  Quit
//
//  Created by Alex Tudge on 13/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QAddCustomNotificationView: View {
    
    var body: some View {
        List {
            NavigationLink(destination: QAddTimeNotificationView()) {
                Text("Add a time based notification")
            }
        }
    }
}

struct QAddCustomNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        QAddCustomNotificationView()
    }
}
