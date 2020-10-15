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
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20) {
                    if goals.count > 0 {
                        Text("Your savings goals")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: geo.size.width * 0.3, height: geo.size.height)
                            .background(Color.pink)
                            .cornerRadius(5)
                    }
                    ForEach(goals) { goal in
                        QFinanceSavingGoalView(goal: goal, profile: profile)
                            .frame(width: geo.size.width * 0.4)
                            .background(LinearGradient(gradient: Gradient(colors: [.pink, .purple]), startPoint: .bottomLeading, endPoint: .topTrailing))
                            .cornerRadius(5)
                    }
                    NavigationLink(destination: QSavingGoalEditView(savingGoal: nil)) {
                        Text("Add a saving goal")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: geo.size.width * 0.3, height: geo.size.height)
                            .background(Color.purple)
                            .cornerRadius(5)
                            .buttonStyle(QButtonStyle())
                    }
                }
            }
        }
    }
}

struct QFinanceSavingGoalListView_Previews: PreviewProvider {
    static var previews: some View {
        QFinanceSavingGoalListView(profile: Profile())
    }
}
