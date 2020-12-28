//
//  QProFeatures.swift
//  Quit
//
//  Created by Alex Tudge on 27/12/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import Foundation

enum QProFeatures: CaseIterable, Identifiable {
    case unlimitedGoals, customAchievements, diary
    
    var id: String {
        title
    }
    
    var title: String {
        switch self {
        case .unlimitedGoals:
            return "Unlimited savings goals"
        case .customAchievements:
            return "Create your own achievements"
        case .diary:
            return "Diary entries"
        }
    }
    
    var message: String {
        switch self {
        case .unlimitedGoals:
            return "Add as many savings goals as you like. This is usually limited to one!"
        case .customAchievements:
            return "Create your own achievements"
        case .diary:
            return "Store diary entries with any cravings you record"
        }
    }
}
