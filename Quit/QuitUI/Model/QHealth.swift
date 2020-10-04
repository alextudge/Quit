//
//  QHealth.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import Foundation

enum QHealth: CaseIterable {
    case pulseNormal, oxygenLevels, nicotineRemoval, monoxideRemoval, nerveEndings, tasteAndSmell, bronchialTubes, oneWeekSuccess, lungPerformance, fertility, heartDisease, lungCancer
    
    func secondsForHealthState() -> Double {
        switch self {
        case .pulseNormal:
            return 1200
        case .oxygenLevels:
            return 28800
        case .nicotineRemoval:
            return 86400
        case .monoxideRemoval:
            return 172800
        case .nerveEndings:
            return 172800
        case .tasteAndSmell:
            return 172800
        case .bronchialTubes:
            return 259200
        case .oneWeekSuccess:
            return 604800
        case .lungPerformance:
            return 1209600
        case .fertility:
            return 7890000
        case .heartDisease:
            return 31536000
        case .lungCancer:
            return 31536000 * 10
        }
    }
    
    var title: String {
        switch self {
        case .pulseNormal:
            return "Pulse normal"
        case .oxygenLevels:
            return "Oxygen levels normal"
        case .nicotineRemoval:
            return "Most nicotine removed"
        case .monoxideRemoval:
            return "All carbon monoxide removed from body"
        case .nerveEndings:
            return "Nerve endings start repairing"
        case .tasteAndSmell:
            return "Taste and smell start improving"
        case .bronchialTubes:
            return "Bronchial tubes relaxing"
        case .oneWeekSuccess:
            return "9 times more likely to quit after reaching one week"
        case .lungPerformance:
            return "30% improvement in lung performance"
        case .fertility:
            return "Fertility and birth related issues reduced"
        case .heartDisease:
            return "Heart disease risk halved"
        case .lungCancer:
            return "Risk of lung cancer halved"
        }
    }
    
    func information() -> String {
        switch self {
        case .pulseNormal:
            return "The heart rate drops and returns to normal"
        case .oxygenLevels:
            return ""
        case .nicotineRemoval:
            return ""
        case .monoxideRemoval:
            return ""
        case .nerveEndings:
            return ""
        case .tasteAndSmell:
            return ""
        case .bronchialTubes:
            return ""
        case .oneWeekSuccess:
            return ""
        case .lungPerformance:
            return ""
        case .fertility:
            return ""
        case .heartDisease:
            return ""
        case .lungCancer:
            return ""
        }
    }
}
