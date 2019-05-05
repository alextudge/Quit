//
//  ViewControllerConstructor.swift
//  Quit
//
//  Created by Alex Tudge on 10/12/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

// swiftlint:disable identifier_name
import UIKit

enum Storyboards: String {
    case Main
    case Settings
    case Other
}

enum ViewControllerFactory: String {
    case HomeViewController
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
        case .SettingsVC,
             .QuitInfoVC:
            return .Settings
        case .AddCravingVC,
             .SavingGoalVC:
            return .Other
        default:
            return .Main
        }
    }
    
    func viewController() -> QuitBaseViewController? {
        return UIStoryboard(name: self.storyboardForViewController().rawValue, bundle: nil)
            .instantiateViewController(withIdentifier: rawValue) as? QuitBaseViewController
    }
}
