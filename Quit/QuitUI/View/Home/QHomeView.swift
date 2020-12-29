//
//  QHomeView.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

//Finish adding health stats
//Reset quit date on didsmoke

import SwiftUI

struct QHomeView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var profile: Profile
    
    var body: some View {
        List {
            Section(header: QListHeaderView(sectionHeader: "Your Quit Date")) {
                QEditQuitDateView(profile: profile)
            }.listRowInsets(EdgeInsets(.zero))
            if !profile.isPro && !profile.hasDismissedProUpsell {
                Section(header: QListHeaderView(sectionHeader: "Quit pro")) {
                    QGoProUpsellView(profile: profile)
                }.listRowInsets(EdgeInsets(.zero))
            }
            Section(header: QListHeaderView(sectionHeader: "Your Finances")) {
                QFinanceListView(profile: profile)
            }.listRowInsets(EdgeInsets(.zero))
            Section(header: QListHeaderView(sectionHeader: "Achievements")) {
                QAchievementHomeView(profile: profile)
            }.listRowInsets(EdgeInsets(.zero))
            Section(header: QListHeaderView(sectionHeader: "Cravings & Triggers")) {
                QCravingsSectionView(profile: profile)
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
                    NavigationLink(destination: QNotificationsHomeView(profile: profile)) {
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
