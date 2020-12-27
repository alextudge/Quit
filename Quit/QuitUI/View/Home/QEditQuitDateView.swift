//
//  QEditQuitDateView.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QEditQuitDateView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var profile: Profile
    @State private var countdownTimer = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack {
            Text(countdownTimer)
                .onReceive(timer) { _ in
                    countdownTimer = Date().offsetFrom(date: profile.quitDate ?? Date())
                }
                .foregroundColor(.white)
            DatePicker("", selection: .init(get: { (
                profile.quitDate ?? Date())
            },
            set: {
                profile.quitDate = $0
                if let quitDate = profile.quitDate,
                   profile.notificationsEnabled {
                    QNotificationManager().setupHealthNotifications(quitDate: quitDate)
                }
                try? managedObjectContext.save()
            })).accentColor(.white)
        }
        .padding()
        .background(Color("section1"))
        .cornerRadius(5)
        .shadow(radius: 4)
        .padding(.horizontal)
    }
}

struct QEditQuitDateView_Previews: PreviewProvider {
    static var previews: some View {
        QEditQuitDateView(profile: Profile())
    }
}
