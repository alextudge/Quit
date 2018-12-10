//
//  ViewControllerConstructor.swift
//  Quit
//
//  Created by Alex Tudge on 10/12/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

struct StoryboardRepresentation {
    let bundle: Bundle?
    let storyboardName: String
    let storyboardId: String
}

enum TypeOfViewController: String {
    case homeVc = "HomeVC"
    case settingsVc = "SettingsVC"
    case achievementsVc = "AchievementsVC"
    case quitInfoVc = "QuitInfoVC"
    case savingsGoalVc = "SavingGoalVC"
    case smokedVc = "SmokedVC"
    case addCravingVc = "AddCravingVC"
    case widgetOnboardingVc = "WidgetOnboardingVC"
}

extension TypeOfViewController {
    func storyboardRepresentation() -> StoryboardRepresentation {
        return StoryboardRepresentation(bundle: nil, storyboardName: "Main", storyboardId: self.rawValue)
    }
}

class ViewControllerFactory: NSObject {
    static func viewController(for typeOfVC: TypeOfViewController) -> UIViewController {
        let metadata = typeOfVC.storyboardRepresentation()
        let storyBoard = UIStoryboard(name: metadata.storyboardName, bundle: metadata.bundle)
        let viewController = storyBoard.instantiateViewController(withIdentifier: metadata.storyboardId)
        return viewController
    }
}
