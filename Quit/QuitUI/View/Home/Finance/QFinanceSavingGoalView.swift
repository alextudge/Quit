//
//  QFinanceGoalView.swift
//  Quit
//
//  Created by Alex Tudge on 10/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QFinanceSavingGoalView: View {
    
    @ObservedObject var goal: SavingGoal
    @ObservedObject var profile: Profile
    
    var body: some View {
        NavigationLink(destination: QSavingGoalEditView(savingGoal: goal)) {
            VStack(alignment: .center) {
                Text(goal.goalName ?? "")
                    .foregroundColor(.white)
                QClockView(progress: profile.savedSoFar / goal.goalAmount)
            }
            .padding()
        }
    }
}

struct QFinanceSavingGoalView_Previews: PreviewProvider {
    static var previews: some View {
        QFinanceSavingGoalView(goal: SavingGoal(), profile: Profile())
    }
}
