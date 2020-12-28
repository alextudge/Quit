//
//  QHomeView.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

// Add Quit pro (todo - simulator error/isPro not being set)
// SwiftUI widget

import SwiftUI

struct QHomeView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var profile: Profile
    
    var body: some View {
        List {
            if !profile.isPro && !profile.hasDismissedProUpsell {
                NavigationLink(destination: QPurchaseProView(profile: profile)) {
                    Text("Go pro")
                }
            }
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
                ZStack {
                   NavigationLink(destination: QNotificationsHomeView()) {
                       EmptyView()
                   }.hidden()
                    Text("Edit your notifications")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color("section8"))
                        .cornerRadius(5)
                        .shadow(radius: 4)
                        .padding(.horizontal)
                }
            }
            .listRowInsets(EdgeInsets(.zero))
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
