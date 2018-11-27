//
//  Constants.swift
//  Quit
//
//  Created by Alex Tudge on 18/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

struct Constants {
    
    struct AppConfig {
        static let group = "group.com.Alex.Quit"
        static let adBannerId = "ca-app-pub-9559625170509646/6744087773"
    }
    
    struct UserDefaults {
        static let appLoadCount = "appLoadCount"
    }
    
    struct QuitDataConstants {
        static let smokedDaily = "smokedDaily"
        static let costOf20 = "costOf20"
        static let quitDate = "quitDate"
        static let vapeSpending = "vapeSpending"
    }
    
    struct Segues {
        static let toQuitInfoVC = "toQuitInfoVC"
        static let toSettingsVC = "toSettingsVC"
        static let toSavingsGoalVC = "toSavingsGoalVC"
        static let toSmokedVC = "toSmokedVC"
        static let toAddCraving = "toAddCraving"
        static let toWidgetInformationVC = "toWidgetInformationVC"
    }
    
    struct Cells {
        static let sectionOneCarouselCell = "SectionOneCarouselCell"
        static let sectionTwoCarouselCell = "SectionTwoCarouselCell"
        static let sectionThreeCarouselCell = "SectionThreeCarouselCell"
        static let sectionFourCarouselCell = "SectionFourCarouselCell"
    }
    
    struct InternalNotifs {
        static let cravingsChanged = NSNotification.Name("cravingsChanged")
        static let savingsChanged = NSNotification.Name("savingsChanged")
        static let quitDateChanged = NSNotification.Name("quitDateChanged")
    }
    
    struct ExternalNotifCategories {
        static let healthProgress = "healthProgressNotification"
    }
    
    struct Colours {
        static let greenColour = UIColor(red: 102/255, green: 204/255, blue: 150/255, alpha: 1)
        static let greenGradient = [UIColor(red:0.71, green:0.93, blue:0.32, alpha:1.0).cgColor, UIColor(red:0.26, green:0.58, blue:0.13, alpha:1.0).cgColor]
        static let blueGradient = [UIColor(red:0.53, green:0.81, blue:0.92, alpha:1.0).cgColor, UIColor(red:0.00, green:0.75, blue:1.00, alpha:1.0).cgColor]
        static let grayGradient = [UIColor(red:0.40, green:0.80, blue:0.00, alpha:1.0).cgColor, UIColor(red:0.71, green:0.93, blue:0.32, alpha:1.0).cgColor]
    }
    
    static let healthStats: [String] =
        ["Pule normal",
         "Oxygen levels normal",
         "Most nicotine removed",
         "All carbon monoxide removed from body",
         "Nerve endings start repairing",
         "Taste and smell start improving",
         "Bronchial tubes relaxing",
         "9 times more likely to quit after reaching one week",
         "30% improvement in lung performance",
         "Fertility and birth related issues reduced",
         "Heart disease risk halved",
         "Risk of lung cancer halved"]
    
    static let savingsInfoAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.white,
         NSAttributedString.Key.backgroundColor: UIColor.black,
         NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 30)!]
}

func secondsForHealthState(healthStat: String) -> Double {
    switch healthStat {
    case "Pule normal":
        return 1200
    case "Oxygen levels normal":
        return 28800
    case "Most nicotine removed":
        return 86400
    case "All carbon monoxide removed from body":
        return 172800
    case "Nerve endings start repairing":
        return 172800
    case "Taste and smell start improving":
        return 172800
    case "Bronchial tubes relaxing":
        return 259200
    case "9 times more likely to quit after reaching one week":
        return 604800
    case "30% improvement in lung performance":
        return 1209600
    case "Fertility and birth related issues reduced":
        return 7890000
    case "Heart disease risk halved":
        return 31536000
    case "Risk of lung cancer halved":
        return 31536000 * 10
    default:
        return 0
    }
}
