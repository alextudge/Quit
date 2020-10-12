//
//  QAchievement.swift
//  Quit
//
//  Created by Alex Tudge on 12/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import Foundation

enum QAchievements: CaseIterable {
    case avoided, oneDay, tenCigarettes, litter, twoDays, threeDays, oneHundredCigarettes, trees
    
    func titleForAchievement() -> String {
        switch self {
        case .avoided:
            return "Cigarettes Avoided"
        case .oneDay:
            return "One day smoke free"
        case .tenCigarettes:
            return "10 cigarettes avoided"
        case .litter:
            return "Cleaning up"
        case .twoDays:
            return "Two days smoke free"
        case .threeDays:
            return "Three days smoke free"
        case .oneHundredCigarettes:
            return "100 cigarettes not smoked"
        case .trees:
            return "Trees you've saved"
        }
    }
    
    func resultsText(profile: Profile) -> (resultstext: String, passed: Bool) {
        var passed = false
        var value = 0.0
        switch self {
        case .avoided:
            value = profile.cigarettesAvoided
            passed = value > 0
        case .oneDay:
            value = profile.daysSmokeFree ?? 0
            passed = value >= 1.0
        case .tenCigarettes:
            value  = profile.daysSmokeFree ?? 0
            passed = profile.cigarettesAvoided >= 10.0
        case .litter:
            value  = profile.cigarettesAvoided
            passed = value > 0
        case .twoDays:
            value = profile.daysSmokeFree ?? 0
            passed = value >= 2
        case .threeDays:
            value = profile.daysSmokeFree ?? 0
            passed = value >= 3
        case .oneHundredCigarettes:
            value = profile.daysSmokeFree ?? 0
            passed = profile.cigarettesAvoided >= 100.0
        case .trees:
            value  = Double((profile.cigarettesAvoided).rounded(toPlaces: 2) / 300).rounded(toPlaces: 2)
            passed = value >= 0
        }
        let text = passed ? successText(value: value) : failureText()
        return (text, passed)
    }
    
    func systemImage() -> String {
        switch self {
        case .avoided:
            return "greaterthan"
        case .oneDay:
            return "clock"
        case .tenCigarettes:
            return "10.circle"
        case .litter:
            return "trash"
        case .twoDays:
            return "hare"
        case .threeDays:
            return "bolt"
        case .oneHundredCigarettes:
            return "flame"
        case .trees:
            return "leaf.arrow.circlepath"
        }
    }
}

private extension QAchievements {
    func successText(value: Double) -> String {
        let intValue = Int(value)
        switch self {
        case .avoided:
            return "You've avoided \(intValue) cigarettes"
        case .oneDay:
            return "Smashed it! You're \(intValue) days free"
        case .tenCigarettes:
            return "10 not smoked is an amazing start, and in just \(intValue) days"
        case .litter:
            return "98% of each butt is micro plastic, and they contain environmentally toxic substances such as arsenic and lead. You've prevented \(intValue) butts from entering the environment"
        case .twoDays:
            return "Amazing, you're \(intValue) days free"
        case .threeDays:
            return "For a lot of people the hardest part is over. Keep it up!"
        case .oneHundredCigarettes:
            return "100 not smoked is an insane achievement, and in just \(intValue) days"
        case .trees:
            return "One tree is used for every 300 cigarettes produced. You've saved \(value) trees"
        }
    }
    
    func failureText() -> String {
        switch self {
        default:
            return "Almost"
        }
    }
}
