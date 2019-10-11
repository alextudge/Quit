//
//  SectionOneCravingDataCellViewModel.swift
//  Quit
//
//  Created by Alex Tudge on 04/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import Foundation
import StoreKit

class SectionOneCravingDataCellViewModel {
    
    var persistenceManager: PersistenceManager?
    var profile: Profile? {
        return persistenceManager?.getProfile()
    }
    
    func stringQuitDate() -> String? {
        guard let quitDate = profile?.quitDate else {
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: quitDate)
    }
    
    func countdownLabel() -> String? {
        guard let quitDate = profile?.quitDate else {
            return nil
        }
        return Date().offsetFrom(date: quitDate)
    }
}
