//
//  QSavingGoalEditView.swift
//  Quit
//
//  Created by Alex Tudge on 12/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QSavingGoalEditView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var savingGoal: SavingGoal?
    @State private var savingGoalName: String = ""
    @State private var savingGoalAmount: String = ""
    
    var body: some View {
        Form {
            TextField("What're you saving for?", text: $savingGoalName)
            TextField("How much does it cost?", text: $savingGoalAmount)
                .keyboardType(.numberPad)
            Button("Save", action: {
                updateOrSaveGoal()
            })
            if savingGoal != nil {
                Button("Delete", action: {
                    deleteSavingGoal()
                })
            }
        }
        .navigationTitle(savingGoal == nil ? "Add Goal" : "Edit Goal")
        .onAppear {
            savingGoalName = savingGoal?.goalName ?? ""
            if let amount = savingGoal?.goalAmount {
                savingGoalAmount = String(amount)
            }
        }
    }
}

private extension QSavingGoalEditView {
    func updateOrSaveGoal() {
        if let savingGoal = savingGoal {
            savingGoal.goalAmount = Double(savingGoalAmount) ?? 0
            savingGoal.goalName = savingGoalName
        } else {
            let savingGoal = SavingGoal(context: managedObjectContext)
            savingGoal.goalAmount = Double(savingGoalAmount) ?? 0
            savingGoal.goalName = savingGoalName
        }
        try? managedObjectContext.save()
        presentationMode.wrappedValue.dismiss()
    }
    
    func deleteSavingGoal() {
        if let goal = savingGoal {
            managedObjectContext.delete(goal)
        }
        try? managedObjectContext.save()
        presentationMode.wrappedValue.dismiss()
    }
}

struct QSavingGoalEditView_Previews: PreviewProvider {
    static var previews: some View {
        QSavingGoalEditView()
    }
}
