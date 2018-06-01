//
//  QuitData.swift
//  Quit
//
//  Created by Alex Tudge on 05/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import Foundation

struct QuitData {
    
    var smokedDaily: Int?
    var costOf20: Double?
    var quitDate: Date?
    
    init(quitData: [String: Any]) {
        
        self.smokedDaily = quitData["smokedDaily"] as? Int
        self.costOf20 = quitData["costOf20"] as? Double
        self.quitDate = quitData["quitDate"] as? Date
    }
    
    //Calculated variables
    
    var costPerCigarette: Double? {
        
        guard let costOfPack = costOf20 else { return nil }
        return Double(costOfPack) / 20.0
    }
    
    var costPerDay: Double? {
        
        guard let costPerCig = costPerCigarette, let daily = smokedDaily else { return nil }
        return costPerCig * Double(daily)
    }
    
    var costPerMinute: Double? {
        
        guard let dailyCost = costPerDay else { return nil }
        return dailyCost / 1440
    }
    
    var costPerWeek: Double? {
        
        guard let dailyCost = costPerDay else { return nil }
        return dailyCost * 7
    }
    
    var costPerYear: Double? {
        
        guard let weeklyCost = costPerWeek else { return nil }
        return weeklyCost * 52
    }
    
    var minuteSmokeFree: Double? {
        
        guard let dateStopped = quitDate else { return nil }
        let secondsSmokeFree = Date().timeIntervalSince(dateStopped)
        return (secondsSmokeFree / 60)
    }
    
    var savedSoFar: Double? {
        
        guard let minutesSmokeFree = minuteSmokeFree, let minuteCost = costPerMinute else { return nil }
        return minutesSmokeFree * minuteCost
    }
}
