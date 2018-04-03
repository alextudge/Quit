//
//  Mocks.swift
//  QuitTests
//
//  Created by Alex Tudge on 03/04/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import Foundation
import CoreData

@testable import Quit

class PersistenceManagerMock: PersistenceManagerProtocol {
    
    func saveContext() {
        return
    }
    
    func addCraving(catagory: String, smoked: Bool) {
        let craving = Craving()
        craving.cravingCatagory = catagory.capitalized
        craving.cravingDate = Date()
        craving.cravingSmoked = smoked
        cravings.append(craving)
    }
    
    func deleteObject(object: NSManagedObject) {
        return
    }
    
    func deleteAllData() {
        return
    }
    
    func addSavingGoal(title: String, cost: Double) {
        let saving = SavingGoal()
        saving.goalName = title
        saving.goalAmount = cost
        savingsGoals.append(saving)
    }
    
    var cravings: [Craving] = [Craving]()
    var savingsGoals: [SavingGoal] = [SavingGoal]()
}
