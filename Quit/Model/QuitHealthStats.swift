//
//  QuitHealthStats.swift
//  Quit
//
//  Created by Alex Tudge on 09/11/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import Foundation

enum HealthStats: String, CaseIterable {
    case pulseNormal = "Pulse normal",
     oxygenLevels = "Oxygen levels normal",
     nicotineRemoval = "Most nicotine removed",
     monoxideRemoval = "All carbon monoxide removed from body",
     nerveEndings = "Nerve endings start repairing",
     tasteAndSmell = "Taste and smell start improving",
     bronchialTubes = "Bronchial tubes relaxing",
     oneWeekSuccess = "9 times more likely to quit after reaching one week",
     lungPerformance = "30% improvement in lung performance",
     fertility = "Fertility and birth related issues reduced",
     heartDisease = "Heart disease risk halved",
     lungCancer = "Risk of lung cancer halved"
    
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
}
