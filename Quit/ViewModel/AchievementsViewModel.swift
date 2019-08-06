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
        guard let quitData = persistenceManager?.quitData else {
            return
        }
        achievements.append(cigarettesAvoided(quitDate: quitData))
        achievements.append(oneDaySmokeFree(quitDate: quitData))
        achievements.append(tenCigarettesNotSmoked(quitDate: quitData))
        achievements.append(twoDaysSmokeFree(quitDate: quitData))
        achievements.append(reducedLitter(quitDate: quitData))
        achievements.append(threeDaysSmokeFree(quitDate: quitData))
        achievements.append(oneHundredCigarettesNotSmoked(quitDate: quitData))
        achievements.append(treesSaved(quitData: quitData))
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
    
    func cigarettesAvoided(quitDate: QuitData) -> Achievement {
        let success = (quitDate.cigarettesAvoided ?? 0) > 0
        return Achievement(title: Achievements.daysSmokeFree.rawValue,
                    result: "You've avoided \(Int(quitDate.cigarettesAvoided ?? 0)) cigarettes",
                    succeded: success)
    }
    
    func oneDaySmokeFree(quitDate: QuitData) -> Achievement {
        let daysSmokeFree = Int(quitDate.daysSmokeFree ?? 0)
        let success = daysSmokeFree > 1
        return Achievement(title: Achievements.oneDaySmokeFree.rawValue,
                           result: success ? "Smashed it! You're \(daysSmokeFree) days free" : "Almost...",
                        succeded: success)
    }
    
    func tenCigarettesNotSmoked(quitDate: QuitData) -> Achievement {
        let success = (quitDate.cigarettesAvoided ?? 0) > 10
        let daysItTakes = 10 / (quitDate.smokedDaily ?? 0)
        return Achievement(title: Achievements.tenCigarettesAvoided.rawValue,
                           result: success ? "10 not smoked is an amazing start, and in just \(daysItTakes) days" : "\(Int(quitDate.cigarettesAvoided ?? 0)) so far...",
            succeded: success)
    }
    
    func reducedLitter(quitDate: QuitData) -> Achievement {
        let success = (quitDate.cigarettesAvoided ?? 0) > 0
        // swiftlint:disable:next line_length
        return Achievement(title: Achievements.reducedWaste.rawValue, result: "98% of each butt is micro plastic, and they contain environmentally toxic substances such as arsenic and lead. You've prevented \(Int(quitDate.cigarettesAvoided ?? 0)) butts from entering the environment", succeded: success)
    }
    
    func twoDaysSmokeFree(quitDate: QuitData) -> Achievement {
        let daysSmokeFree = Int(quitDate.daysSmokeFree ?? 0)
        let success = daysSmokeFree > 2
        return Achievement(title: Achievements.twoDaysSmokeFree.rawValue,
                           result: success ? "Amazing, you're \(daysSmokeFree) days free" : "Almost...",
                           succeded: success)
    }
    
    func threeDaysSmokeFree(quitDate: QuitData) -> Achievement {
        let daysSmokeFree = Int(quitDate.daysSmokeFree ?? 0)
        let success = daysSmokeFree > 3
        return Achievement(title: Achievements.threedaysSmokeFree.rawValue,
                           result: success ? "For a lot of people the hardest part is over. Keep it up!" : "Almost...",
                           succeded: success)
    }
    
    func oneHundredCigarettesNotSmoked(quitDate: QuitData) -> Achievement {
        let success = (quitDate.cigarettesAvoided ?? 0) > 100
        let daysItTakes = 100 / (quitDate.smokedDaily ?? 0)
        return Achievement(title: Achievements.oneHundredCigarettesAvoided.rawValue,
                           result: success ? "100 not smoked is an insane achievement, and in just \(daysItTakes) days" : "\(Int(quitDate.cigarettesAvoided ?? 0)) so far...",
                           succeded: success)
    }
    
    func treesSaved(quitData: QuitData) -> Achievement {
        let result = Double((quitData.cigarettesAvoided ?? 0).rounded(toPlaces: 2) / 300).rounded(toPlaces: 2)
        return Achievement(title: Achievements.savedATree.rawValue,
                           result: "One tree is used for every 300 cigarettes produced. You've saved \(result) trees",
                           succeded: result > 0)
    }
}
