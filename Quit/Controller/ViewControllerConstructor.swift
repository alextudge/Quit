//
//  ViewControllerConstructor.swift
//  Quit
//
//  Created by Alex Tudge on 10/12/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

enum Storyboards: String {
    // swiftlint:disable identifier_name
    case Main
}

enum ViewControllerFactory: String {
    case HomeVC
    case SettingsVC
    case AchievementsVC
    case QuitInfoVC
    case SavingGoalVC
    case SmokedVC
    case AddCravingVC
    case WidgetOnboardingVC
    case ReasonsOnboardingVC
    case EditArrayVC
    
    func storyboardForViewController() -> Storyboards {
        switch self {
        default:
            return .Main
        }
    }
    
    func viewController() -> QuitBaseViewController? {
        return UIStoryboard(name: self.storyboardForViewController().rawValue, bundle: nil)
            .instantiateViewController(withIdentifier: rawValue) as? QuitBaseViewController
    }
}
