//
//  QuitData.swift
//  Quit
//
//  Created by Alex Tudge on 05/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import Foundation

struct QuitData {
    var smokedDaily: Int
    var costOf20: Int
    var quitDate: Date
    var costPerCigarette: Double {
        return Double(self.costOf20) / 20.0
    }
    var costPerDay: Double {
        return self.costPerCigarette * Double(self.smokedDaily)
    }
    var costPerMinute: Double {
        return self.costPerDay / 1440
    }
    var costPerWeek: Double {
        return self.costPerDay * 7
    }
    var costPerYear: Double {
        return self.costPerWeek * 52
    }
    var savedSoFar: Double {
        let secondsSmokeFree = Date().timeIntervalSince(self.quitDate)
        return (secondsSmokeFree / 60) * costPerMinute
    }
}
