//
//  QAchievementView.swift
//  Quit
//
//  Created by Alex Tudge on 12/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QAchievementView: View {
    
    let achievement: QAchievements
    @ObservedObject var profile: Profile
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: achievement.systemImage())
                Text(achievement.titleForAchievement())
                    .multilineTextAlignment(.leading)
                    .font(.headline)
            }
            Spacer()
            Text(achievement.resultsText(profile: profile).resultstext)
                .multilineTextAlignment(.leading)
                .foregroundColor(achievement.resultsText(profile: profile).passed ? .primary : .secondary)
        }
        .padding()
    }
}

struct QAchievementView_Previews: PreviewProvider {
    static var previews: some View {
        QAchievementView(achievement: QAchievements.avoided, profile: Profile())
    }
}
