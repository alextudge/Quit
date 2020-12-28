//
//  QFinanceSavingGoalListView.swift
//  Quit
//
//  Created by Alex Tudge on 12/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QFinanceSavingGoalListView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: SavingGoal.entity(),
        sortDescriptors: []
    ) var goals: FetchedResults<SavingGoal>
    @ObservedObject var profile: Profile
    
    private var canAddMoreGoals: Bool {
        goals.count <= 1 || profile.isPro
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(goals) { goal in
                    QFinanceSavingGoalView(goal: goal, profile: profile)
                        .background(Color("section3"))
                        .cornerRadius(5)
                        .shadow(radius: 5)
                }
                if canAddMoreGoals {
                    NavigationLink(destination: QSavingGoalEditView(savingGoal: nil)) {
                        Text("Add a saving goal")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("section3"))
                            .cornerRadius(5)
                            .buttonStyle(QButtonStyle())
                            .shadow(radius: 5)
                    }
                } else {
                    NavigationLink(destination: QSavingGoalEditView(savingGoal: nil)) {
                        Text("Go pro to add unlimited goals!")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("section3"))
                            .cornerRadius(5)
                            .buttonStyle(QButtonStyle())
                            .shadow(radius: 5)
                    }
                }
            }
            .padding([.leading, .trailing])
        }
    }
}

struct QFinanceSavingGoalListView_Previews: PreviewProvider {
    static var previews: some View {
        QFinanceSavingGoalListView(profile: Profile())
    }
}
