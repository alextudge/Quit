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
    @State private var showingAlert = false
    
    var body: some View {
        Form {
            TextField("What're you saving for?", text: $savingGoalName)
            TextField("How much does it cost?", text: $savingGoalAmount)
                .keyboardType(.numberPad)
            Button("Save", action: {
                if savingGoalName.isEmpty || !savingGoalAmount.isNumber {
                    showingAlert = true
                } else {
                    updateOrSaveGoal()
                }
            })
            .buttonStyle(QButtonStyle())
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
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("🤕"), message: Text("Both text fields are required."), dismissButton: .default(Text("Got it!")))
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
