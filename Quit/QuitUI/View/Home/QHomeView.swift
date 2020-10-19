//
//  QHomeView.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

// Sync with iCloud
// Add Quit pro
// SwiftUI widget
// Add vape section

import SwiftUI

struct QHomeView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var profile: Profile
    
    var body: some View {
        GeometryReader { geo in
            List {
                Section(header: Text("Highlights")) {
                    QHeadlineGuageListView(profile: profile)
                        .frame(height: geo.size.height * 0.25)
                }
                Section(header: Text("Your Quit Date")) {
                    QEditQuitDateView(profile: profile)
                }
                Section(header: Text("Your Finances")) {
                    QFinanceListView(profile: profile)
                        .frame(height: geo.size.height * 0.3)
                }
                Section(header: Text("Achievements")) {
                    QAchievementHomeView(profile: profile)
                }
                Section(header: Text("Cravings & Triggers")) {
                    QCravingsSectionView()
                        .frame(height: geo.size.height * 0.3)
                }
                Section(header: Text("Your Health")) {
                    QHealthListView(profile: profile)
                        .frame(height: geo.size.height * 0.3)
                }
                Section(header: Text("Notifications")) {
                    NavigationLink(destination: QNotificationsHomeView()) {
                        Text("Location Notification")
                    }
                }
            }
            .listStyle(SidebarListStyle())
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(trailing:
            NavigationLink(destination: QSettingsView(profile: profile)) {
                Label("Settings", systemImage: "slider.horizontal.3")
            }
        )
    }
}

struct QHomeView_Previews: PreviewProvider {
    static var previews: some View {
        QHomeView(profile: Profile())
    }
}
