//
//  QViewAchievementsView.swift
//  Quit
//
//  Created by Alex Tudge on 12/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QViewAchievementsView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Achievement.entity(), sortDescriptors: []) var achievements: FetchedResults<Achievement>
    @ObservedObject var profile: Profile
    
    var body: some View {
        List {
            ForEach(QAchievements.allCases, id: \.self) { achievement in
                QAchievementView(achievement: achievement, profile: profile)
            }
            if !achievements.isEmpty {
                Section(header: Text("Custom achievements")) {
                    ForEach(achievements) { achievement in
                        Text("\(achievement.name ?? "")")
                    }
                }
            }
            if profile.isPro {
                NavigationLink(destination: QAddCustomAchievementView()) {
                    Text("Add a custom achievement")
                }
            } else {
                NavigationLink(destination: QPurchaseProView(profile: profile)) {
                    Text("Go pro to add custom achievements!")
                }
            }
        }
        .navigationTitle("Achievements")
    }
}

struct QViewAchievementsView_Previews: PreviewProvider {
    static var previews: some View {
        QViewAchievementsView(profile: Profile())
    }
}
