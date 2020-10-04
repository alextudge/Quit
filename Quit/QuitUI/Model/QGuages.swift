//
//  QGuages.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

enum QGuage: CaseIterable {
    
    case finance, overallHealth, freeTime, oneDay
    
    var nameForHeadline: String {
        switch self {
        case .oneDay:
            return "Day 1 complete"
        case .finance:
            return "£100 saved"
        case .overallHealth:
            return "First 5 Health Improvements"
        case .freeTime:
            return "100 Minutes Regained"
        }
    }
    
    func progress(profile: Profile) -> Double {
        switch self {
        case .oneDay:
            return Double(profile.minutesSmokeFree ?? 0) / 1440
        case .freeTime:
            return Double(profile.minutesRegained ?? 0) / 100
        case .finance:
            return Double(profile.savedSoFar ?? 0) / 100
        case .overallHealth:
            let secondsSoFar = profile.secondsSmokeFree ?? 0
            let healthStatsPassed = QHealth.allCases.filter { Int($0.secondsForHealthState()) < secondsSoFar }.count
            return Double(healthStatsPassed / 5)
        }
    }
    
    var colour: Color {
        switch self {
        default:
            return .blue
        }
    }
}
