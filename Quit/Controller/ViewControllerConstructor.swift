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
    case Home
    case Settings
    case Other
}

enum ViewControllerFactory: String {
    case HomeViewController
    case SettingsVC
    case AchievementsVC
    case QuitInfoViewController
    case SavingGoalVC
    case SmokedVC
    case AddCravingVC
    case WidgetOnboardingVC
    case ReasonsOnboardingVC
    case EditArrayVC
    case CravingsViewController
    case ViewPendingNotificationsViewContoller
    case AddNotificationViewController
    case QuitHealthSummaryViewController
    
    func storyboardForViewController() -> Storyboards {
        switch self {
        case .SettingsVC,
             .QuitInfoViewController:
            return .Settings
        case .AddCravingVC,
             .SavingGoalVC,
             .CravingsViewController,
             .ViewPendingNotificationsViewContoller,
             .AddNotificationViewController,
             .QuitHealthSummaryViewController:
            return .Other
        default:
            return .Home
        }
    }
    
    func viewController() -> QuitBaseViewController? {
        return UIStoryboard(name: self.storyboardForViewController().rawValue, bundle: nil)
            .instantiateViewController(withIdentifier: rawValue) as? QuitBaseViewController
    }
}
