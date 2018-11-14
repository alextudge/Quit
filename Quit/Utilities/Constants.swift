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
    }
    
    struct Cells {
        static let sectionOneCarouselCell = "SectionOneCarouselCell"
        static let sectionTwoCarouselCell = "SectionTwoCarouselCell"
        static let sectionThreeCarouselCell = "SectionThreeCarouselCell"
        static let sectionFourCarouselCell = "SectionFourCarouselCell"
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
    
    struct Colours {
        static let greenColour = UIColor(red: 102/255, green: 204/255, blue: 150/255, alpha: 1)
    }
    
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
