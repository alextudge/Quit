//
//  QAchievementHomeView.swift
//  Quit
//
//  Created by Alex Tudge on 13/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QAchievementHomeView: View {
    
    @ObservedObject var profile: Profile
    private var achievementsAchieved: Int {
        QAchievements.allCases.compactMap {
            $0.resultsText(profile: profile).passed
        }.count
    }
    
    var body: some View {
        NavigationLink(destination: QViewAchievementsView(profile: profile)) {
            VStack(alignment: .leading, spacing: 5) {
                Text("\(achievementsAchieved) achieved!")
                    .font(.headline)
                Text("Tap here to see them all.")
                    .font(.subheadline)
            }
            .padding()
        }
        .frame(minWidth: 100, maxWidth: .infinity, minHeight: 44, alignment: .leading)
        .background(Color(UIColor.tertiarySystemBackground))
        .cornerRadius(5)
    }
}

struct QAchievementHomeView_Previews: PreviewProvider {
    static var previews: some View {
        QAchievementHomeView(profile: Profile())
    }
}
