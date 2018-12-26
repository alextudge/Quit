//
//  AchievementsViewModel.swift
//  Quit
//
//  Created by Alex Tudge on 11/12/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import Foundation

struct Achievement {
    var title: String?
    var result: String?
    var succeded: Bool
}

class AchievementsViewModel {
    
    var persistenceManager = PersistenceManager()
    
    func processAchievements() -> [Achievement] {
        guard let quitDate = persistenceManager.quitData else {
            return []
        }
        var achievements = [Achievement]()
        achievements.append(notSmokedAchievementDays(quitDate: quitDate))
        achievements.append(hasReachedOneDayAchievement(quitDate: quitDate))
        return achievements
    }
}

private extension AchievementsViewModel {
    enum Achievements: String {
        case daysSmokeFree = "Cigarettes avoided",
        oneDaySmokeFree = "Days smoke free"
    }
    
    func notSmokedAchievementDays(quitDate: QuitData) -> Achievement {
        let hasSucceeded = (quitDate.notSmokedSoFar ?? 0) > 0
        return Achievement(title: Achievements.daysSmokeFree.rawValue,
                    result: "\(quitDate.notSmokedSoFar ?? 0)",
                    succeded: hasSucceeded)
    }
    
    func hasReachedOneDayAchievement(quitDate: QuitData) -> Achievement {
        let daysSmokeFree = ((quitDate.minuteSmokeFree ?? 0) / 1440)
        let daysSmokeFreeRounded = Int(daysSmokeFree.rounded(.toNearestOrAwayFromZero))
        return Achievement(title: Achievements.oneDaySmokeFree.rawValue,
                        result: "\(daysSmokeFreeRounded)",
                        succeded: daysSmokeFreeRounded > 1)
    }
}
