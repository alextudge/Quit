//
//  HomeVCViewModel.swift
//  Quit
//
//  Created by Alex Tudge on 04/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class HomeVCViewModel {
    
    private(set) var persistenceManager = PersistenceManager()
    
    func sizeForCellOf(type: Int) -> CGFloat {
        switch type {
        case 0, 1, 2:
            return UIScreen.main.bounds.height / 2.2
        case 3:
            return UIScreen.main.bounds.height / 2
        default:
            return UIScreen.main.bounds.height
        }
    }
    
    func titleForHeaderOf(section: Int) -> String {
        switch section {
        case 0:
            return "Your quit date"
        case 1:
            return "Your finances"
        case 2:
            return "Your cravings"
        case 3:
            return "Your health"
        default:
            return ""
        }
    }
}
