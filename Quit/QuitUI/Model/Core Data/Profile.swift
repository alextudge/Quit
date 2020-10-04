//
//  Profile.swift
//  Quit
//
//  Created by Alex Tudge on 05/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import Foundation

extension Profile {
    var costPerDay: Double? {
        guard let costPerCigarette = costPerCigarette,
            let smokedDaily = smokedDaily else {
                return nil
        }
        return costPerCigarette * Double(truncating: smokedDaily)
    }
    
    var costPerYear: Double? {
        guard let costPerWeek = costPerWeek else {
            return nil
        }
        return costPerWeek * 52
    }
    
    var minutesSmokeFree: Double? {
        guard let quitDate = quitDate else {
            return nil
        }
        let secondsSmokeFree = Date().timeIntervalSince(quitDate)
        return secondsSmokeFree / 60
    }
    
    var secondsSmokeFree: Int? {
        guard let quitDate = quitDate else {
            return nil
        }
        return Int(Date().timeIntervalSince(quitDate))
    }
    
    var daysSmokeFree: Double? {
        guard let minutesSmokeFree = minutesSmokeFree else {
            return nil
        }
        return minutesSmokeFree / 1440
    }
    
    var savedSoFar: Double? {
        guard let minutesSmokeFree = minutesSmokeFree,
            let costPerMinute = costPerMinute else {
                return nil
        }
        return minutesSmokeFree * costPerMinute
    }
    
    var vapingSavings: Double? {
        guard let savedSoFar = savedSoFar,
            let vapeSpend = vapeSpending else {
                return nil
        }
        return savedSoFar - vapeSpend.doubleValue
    }
    
    var cigarettesAvoided: Double? {
        guard let smokedPerMinute = smokedPerMinute,
            let minutesSmokeFree = minutesSmokeFree else {
            return nil
        }
        return smokedPerMinute * minutesSmokeFree
    }
    
    var minutesRegained: Int? {
        guard let cigarettesAvoided = cigarettesAvoided else {
            return nil
        }
        return Int(cigarettesAvoided) * 5
    }
}

private extension Profile {
    var costPerCigarette: Double? {
        guard let costOf20 = costOf20 else {
            return nil
        }
        return Double(truncating: costOf20) / 20.0
    }
    
    var costPerMinute: Double? {
        guard let costPerDay = costPerDay else {
            return nil
        }
        return costPerDay / 1440
    }
    
    var costPerWeek: Double? {
        guard let costPerDay = costPerDay else {
            return nil
        }
        return costPerDay * 7
    }
    
    var smokedPerMinute: Double? {
        guard let smokedDaily = smokedDaily else {
            return nil
        }
        return Double(truncating: smokedDaily) / 1440
    }
}
