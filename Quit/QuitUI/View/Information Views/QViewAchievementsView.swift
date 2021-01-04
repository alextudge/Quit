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
                        QCustomAchievementView(achievement: achievement, profile: profile)
                    }
                    .onDelete(perform: delete)
                }
            }
            if profile.isPro {
                NavigationLink(destination: QAddCustomAchievementView()) {
                    HStack {
                        Text("Add a custom achievement")
                    }
                    .padding()
                    .background(Color.green)
                    .cornerRadius(5)
                }
            } else {
                NavigationLink(destination: QPurchaseProView(profile: profile)) {
                    Text("Go pro to add custom achievements!")
                        .padding()
                        .cornerRadius(5)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .shadow(radius: 5)
                }
            }
        }
        .navigationTitle("Achievements")
        .navigationBarItems(trailing: EditButton())
    }
}

private extension QViewAchievementsView {
    func delete(at offsets: IndexSet) {
        offsets.forEach {
            managedObjectContext.delete(achievements[$0])
        }
        DispatchQueue.main.async {
            try? managedObjectContext.save()
        }
    }
}

struct QViewAchievementsView_Previews: PreviewProvider {
    static var previews: some View {
        QViewAchievementsView(profile: Profile())
    }
}
