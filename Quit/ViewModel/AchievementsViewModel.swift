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
    
    private var persistenceManager: PersistenceManager?
    private(set) var achievements = [Achievement]()
    
    init(persistenceManager: PersistenceManager?) {
        self.persistenceManager = persistenceManager
        processAchievements()
    }
    
    func processAchievements() {
        guard let profile = persistenceManager?.getProfile() else {
            return
        }
        achievements.append(cigarettesAvoided(quitDate: profile))
        achievements.append(oneDaySmokeFree(quitDate: profile))
        achievements.append(tenCigarettesNotSmoked(quitDate: profile))
        achievements.append(twoDaysSmokeFree(quitDate: profile))
        achievements.append(reducedLitter(quitDate: profile))
        achievements.append(threeDaysSmokeFree(quitDate: profile))
        achievements.append(oneHundredCigarettesNotSmoked(quitDate: profile))
        achievements.append(treesSaved(profile: profile))
    }
}

private extension AchievementsViewModel {
    enum Achievements: String {
        case daysSmokeFree = "Cigarettes avoided",
        oneDaySmokeFree = "One day smoke free",
        twoDaysSmokeFree = "Two days smoke free",
        threedaysSmokeFree = "Three days smoke free",
        oneHundredCigarettesAvoided = "100 cigarettes not smoked",
        tenCigarettesAvoided = "10 cigarettes not smoked",
        reducedWaste = "Your most basic environmental impact",
        savedATree = "Trees saved"
    }
    
    func cigarettesAvoided(quitDate: Profile) -> Achievement {
        let success = (quitDate.cigarettesAvoided ?? 0) > 0
        return Achievement(title: Achievements.daysSmokeFree.rawValue,
                    result: "You've avoided \(Int(quitDate.cigarettesAvoided ?? 0)) cigarettes",
                    succeded: success)
    }
    
    func oneDaySmokeFree(quitDate: Profile) -> Achievement {
        let daysSmokeFree = Int(quitDate.daysSmokeFree ?? 0)
        let success = daysSmokeFree > 1
        return Achievement(title: Achievements.oneDaySmokeFree.rawValue,
                           result: success ? "Smashed it! You're \(daysSmokeFree) days free" : "Almost...",
                        succeded: success)
    }
    
    func tenCigarettesNotSmoked(quitDate: Profile) -> Achievement {
        let success = (quitDate.cigarettesAvoided ?? 0) > 10
        let daysItTakes = 10 / (quitDate.smokedDaily?.intValue ?? 0)
        return Achievement(title: Achievements.tenCigarettesAvoided.rawValue,
                           result: success ? "10 not smoked is an amazing start, and in just \(daysItTakes) days" : "\(Int(quitDate.cigarettesAvoided ?? 0)) so far...",
            succeded: success)
    }
    
    func reducedLitter(quitDate: Profile) -> Achievement {
        let success = (quitDate.cigarettesAvoided ?? 0) > 0
        // swiftlint:disable:next line_length
        return Achievement(title: Achievements.reducedWaste.rawValue, result: "98% of each butt is micro plastic, and they contain environmentally toxic substances such as arsenic and lead. You've prevented \(Int(quitDate.cigarettesAvoided ?? 0)) butts from entering the environment", succeded: success)
    }
    
    func twoDaysSmokeFree(quitDate: Profile) -> Achievement {
        let daysSmokeFree = Int(quitDate.daysSmokeFree ?? 0)
        let success = daysSmokeFree > 2
        return Achievement(title: Achievements.twoDaysSmokeFree.rawValue,
                           result: success ? "Amazing, you're \(daysSmokeFree) days free" : "Almost...",
                           succeded: success)
    }
    
    func threeDaysSmokeFree(quitDate: Profile) -> Achievement {
        let daysSmokeFree = Int(quitDate.daysSmokeFree ?? 0)
        let success = daysSmokeFree > 3
        return Achievement(title: Achievements.threedaysSmokeFree.rawValue,
                           result: success ? "For a lot of people the hardest part is over. Keep it up!" : "Almost...",
                           succeded: success)
    }
    
    func oneHundredCigarettesNotSmoked(quitDate: Profile) -> Achievement {
        let success = (quitDate.cigarettesAvoided ?? 0) > 100
        let daysItTakes = 100 / (quitDate.smokedDaily?.intValue ?? 0)
        return Achievement(title: Achievements.oneHundredCigarettesAvoided.rawValue,
                           result: success ? "100 not smoked is an insane achievement, and in just \(daysItTakes) days" : "\(Int(quitDate.cigarettesAvoided ?? 0)) so far...",
                           succeded: success)
    }
    
    func treesSaved(profile: Profile) -> Achievement {
        let result = Double((profile.cigarettesAvoided ?? 0).rounded(toPlaces: 2) / 300).rounded(toPlaces: 2)
        return Achievement(title: Achievements.savedATree.rawValue,
                           result: "One tree is used for every 300 cigarettes produced. You've saved \(result) trees",
                           succeded: result > 0)
    }
}
