//
//  QFinance.swift
//  Quit
//
//  Created by Alex Tudge on 10/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import Foundation

enum QFinance: CaseIterable {
    case daily, weekly, annual, soFar, lifetime
    
    var title: String {
        switch self {
        case .daily:
            return "Daily"
        case .weekly:
            return "Weekly"
        case .annual:
            return "Annually"
        case .soFar:
            return "So far"
        case .lifetime:
            return "Lifetime"
        }
    }
    
    func minutesForPeriod(minutesSmokeFree: Double) -> Int {
        switch self {
        case .daily:
            return 1440
        case .weekly:
            return 10080
        case .annual:
            return 525600
        case .soFar:
            return Int(minutesSmokeFree)
        case .lifetime:
            return 525600 * 60
        }
    }
}
