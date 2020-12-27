//
//  QHomeView.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

// Add Quit pro
// SwiftUI widget
// Trigger doesnt work for exisiting ones
// Savings chart is too small

import SwiftUI

struct QHomeView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var profile: Profile
    
    var body: some View {
        List {
            Section(header: QListHeaderView(sectionHeader: "Your Quit Date")) {
                QEditQuitDateView(profile: profile)
            }.listRowInsets(EdgeInsets(.zero))
            Section(header: QListHeaderView(sectionHeader: "Your Finances")) {
                QFinanceListView(profile: profile)
            }.listRowInsets(EdgeInsets(.zero))
            Section(header: QListHeaderView(sectionHeader: "Achievements")) {
                QAchievementHomeView(profile: profile)
            }.listRowInsets(EdgeInsets(.zero))
            Section(header: QListHeaderView(sectionHeader: "Cravings & Triggers")) {
                QCravingsSectionView()
            }.listRowInsets(EdgeInsets(.zero))
            Section(header: QListHeaderView(sectionHeader: "Vape spend")) {
                QVapeSpendView(profile: profile)
                    .padding(.horizontal)
            }.listRowInsets(EdgeInsets(.zero))
            Section(header: QListHeaderView(sectionHeader: "Your Health")) {
                QHealthListView(profile: profile)
            }.listRowInsets(EdgeInsets(.zero))
            Section(header: QListHeaderView(sectionHeader: "Notifications")) {
                NavigationLink(destination: QNotificationsHomeView()) {
                    Text("Edit your notifications")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color("section8"))
                        .cornerRadius(5)
                        .shadow(radius: 4)
                        .padding(.horizontal)
                }
            }.listRowInsets(EdgeInsets(.zero))
        }
        .navigationBarTitle("Quit", displayMode: .automatic)
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
