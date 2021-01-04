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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var name = ""
    @State private var successText = ""
    @State private var failureText = ""
    @State private var numberOfCigarettes = ""
    @State private var showingAlert = false
    
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
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("🤕"), message: Text("Please complete all fields in the right format."), dismissButton: .default(Text("Got it!")))
        }
    }
}

private extension QAddCustomAchievementView {
    func saveAchievement() {
        guard !name.isEmpty,
              !successText.isEmpty,
              !failureText.isEmpty,
              numberOfCigarettes.isNumber else {
            showingAlert = true
            return
        }
        let achievement = Achievement(context: managedObjectContext)
        achievement.name = name
        achievement.successText = successText
        achievement.failureText = failureText
        achievement.targetCigarettes = Int64(numberOfCigarettes) ?? 0
        try? managedObjectContext.save()
        presentationMode.wrappedValue.dismiss()
    }
}

struct QAddCustomAchievementView_Previews: PreviewProvider {
    static var previews: some View {
        QAddCustomAchievementView()
    }
}
