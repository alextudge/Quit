//
//  QViewAchievementsView.swift
//  Quit
//
//  Created by Alex Tudge on 12/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QViewAchievementsView: View {
    
    @ObservedObject var profile: Profile
    
    var body: some View {
        List {
            ForEach(QAchievements.allCases, id: \.self) { achievement in
                QAchievementView(achievement: achievement, profile: profile)
            }
        }
    }
}

struct QViewAchievementsView_Previews: PreviewProvider {
    static var previews: some View {
        QViewAchievementsView(profile: Profile())
    }
}
