//
//  QProFeatures.swift
//  Quit
//
//  Created by Alex Tudge on 27/12/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import Foundation

enum QProFeatures: CaseIterable, Identifiable {
    case unlimitedGoals, customAchievements, unlimitedNotifications, extraSupport
    
    var id: String {
        title
    }
    
    var title: String {
        switch self {
        case .unlimitedGoals:
            return "Unlimited savings goals"
        case .customAchievements:
            return "Create your own achievements"
        case .unlimitedNotifications:
            return "Unlimited custom notifications"
        case .extraSupport:
            return "Exclusive tips and messages"
        }
    }
    
    var message: String {
        switch self {
        case .unlimitedGoals:
            return "Add as many savings goals as you like. This is usually limited to two!"
        case .customAchievements:
            return "Create your own achievements"
        case .unlimitedNotifications:
            return "Unlimited custom notifications"
        case .extraSupport:
            return "Exclusive tips and messaages"
        }
    }
}
