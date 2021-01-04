//
//  QCustomAchievementView.swift
//  Quit
//
//  Created by Alex Tudge on 29/12/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QCustomAchievementView: View {
    
    @ObservedObject var achievement: Achievement
    @ObservedObject var profile: Profile
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "bolt.heart.fill")
                Text(achievement.name ?? "")
                    .multilineTextAlignment(.leading)
                    .font(.headline)
            }
            Spacer()
            Text(achievementMessage(achievement))
                .multilineTextAlignment(.leading)
        }
        .padding()
    }
}

private extension QCustomAchievementView {
    func achievementMessage(_ achievement: Achievement) -> String {
        if achievement.targetCigarettes >= Int64(profile.cigarettesAvoided) {
            return achievement.failureText ?? ""
        } else {
            return achievement.successText ?? ""
        }
    }
}

struct QCustomAchievementView_Previews: PreviewProvider {
    static var previews: some View {
        QCustomAchievementView(achievement: Achievement(), profile: Profile())
    }
}
