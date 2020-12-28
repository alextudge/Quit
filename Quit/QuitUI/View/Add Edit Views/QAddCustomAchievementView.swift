//
//  QAddCustomAchievementView.swift
//  Quit
//
//  Created by Alex Tudge on 28/12/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QAddCustomAchievementView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var name = ""
    @State private var successText = ""
    @State private var failureText = ""
    @State private var numberOfCigarettes = ""
    
    var body: some View {
        Form {
            TextField("Name of achievement", text: $name)
            TextField("How many cigarettes to meet this target?", text: $numberOfCigarettes)
                .keyboardType(.numberPad)
            Section(header: Text("Outcomes")) {
                TextField("Success message", text: $successText)
                TextField("Failure message", text: $failureText)
            }
            Button("Save achievement", action: {
                saveAchievement()
            })
            .buttonStyle(QButtonStyle())
        }
        .navigationTitle("Add an achievement")
    }
}

private extension QAddCustomAchievementView {
    func saveAchievement() {
        let achievement = Achievement(context: managedObjectContext)
        achievement.name = name
        achievement.successText = successText
        achievement.failureText = failureText
        achievement.targetCigarettes = Int64(numberOfCigarettes) ?? 0
        try? managedObjectContext.save()
    }
}

struct QAddCustomAchievementView_Previews: PreviewProvider {
    static var previews: some View {
        QAddCustomAchievementView()
    }
}
