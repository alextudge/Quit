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
        achievements.append(cigarettesAvoided(quitDate: quitDate))
        achievements.append(oneDaySmokeFree(quitDate: quitDate))
        return achievements
    }
}

private extension AchievementsViewModel {
    enum Achievements: String {
        case daysSmokeFree = "Cigarettes avoided",
        oneDaySmokeFree = "Days smoke free"
    }
    
    func cigarettesAvoided(quitDate: QuitData) -> Achievement {
        let hasSucceeded = (quitDate.cigarettesAvoided ?? 0) > 0
        return Achievement(title: Achievements.daysSmokeFree.rawValue,
                    result: "You've avoided \(Int(quitDate.cigarettesAvoided ?? 0)) cigarettes",
                    succeded: hasSucceeded)
    }
    
    func oneDaySmokeFree(quitDate: QuitData) -> Achievement {
        let daysSmokeFree = ((quitDate.minutesSmokeFree ?? 0) / 1440)
        let daysSmokeFreeRounded = Int(daysSmokeFree.rounded(.toNearestOrAwayFromZero))
        return Achievement(title: Achievements.oneDaySmokeFree.rawValue,
                        result: "\(daysSmokeFreeRounded)",
                        succeded: daysSmokeFreeRounded > 1)
    }
}
