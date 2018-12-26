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
        static let appName = "Quit"
        static let appGroupId = "group.com.Alex.Quit"
        static let adAppId = "ca-app-pub-9559625170509646~1544442423"
        static let adBannerId = "ca-app-pub-9559625170509646/6744087773"
    }
    
    struct UserDefaults {
        static let quitData = "quitData"
        static let appLoadCount = "appLoadCount"
    }
    
    struct CoreData {
        static let craving = "Craving"
        static let savingGoal = "SavingGoal"
        static let coreDataObjects = [craving, savingGoal]
        static let databaseId = "Quit.sqlite"
    }
    
    struct QuitDataConstants {
        static let smokedDaily = "smokedDaily"
        static let costOf20 = "costOf20"
        static let quitDate = "quitDate"
        static let vapeSpending = "vapeSpending"
    }
    
    struct Cells {
        static let sectionOneCarouselCell = "SectionOneCarouselCell"
        static let sectionTwoCarouselCell = "SectionTwoCarouselCell"
        static let sectionThreeCarouselCell = "SectionThreeCarouselCell"
        static let sectionFourCarouselCell = "SectionFourCarouselCell"
        static let sectionFiveCarouselCell = "SectionFiveCarouselCell"
        static let achievementCell = "achievementCell"
    }
    
    struct InternalNotifs {
        static let cravingsChanged = NSNotification.Name("cravingsChanged")
        static let savingsChanged = NSNotification.Name("savingsChanged")
        static let quitDateChanged = NSNotification.Name("quitDateChanged")
    }
    
    struct ExternalNotifCategories {
        static let healthProgress = "healthProgressNotification"
    }
    
    enum HealthStats: String, CaseIterable {
        case pulseNormal = "Pulse normal",
         oxygenLevels = "Oxygen levels normal",
         nicotineRemoval = "Most nicotine removed",
         monoxideRemoval = "All carbon monoxide removed from body",
         nerveEndings = "Nerve endings start repairing",
         tasteAndSmell = "Taste and smell start improving",
         bronchialTubes = "Bronchial tubes relaxing",
         oneWeekSuccess = "9 times more likely to quit after reaching one week",
         lungPerformance = "30% improvement in lung performance",
         fertility = "Fertility and birth related issues reduced",
         heartDisease = "Heart disease risk halved",
         lungCancer = "Risk of lung cancer halved"
        
        func secondsForHealthState() -> Double {
            switch self {
            case .pulseNormal:
                return 1200
            case .oxygenLevels:
                return 28800
            case .nicotineRemoval:
                return 86400
            case .monoxideRemoval:
                return 172800
            case .nerveEndings:
                return 172800
            case .tasteAndSmell:
                return 172800
            case .bronchialTubes:
                return 259200
            case .oneWeekSuccess:
                return 604800
            case .lungPerformance:
                return 1209600
            case .fertility:
                return 7890000
            case .heartDisease:
                return 31536000
            case .lungCancer:
                return 31536000 * 10
            }
        }
    }
}

struct Styles {
    struct Colours {
        static let greenColour = UIColor(red: 102/255, green: 204/255, blue: 150/255, alpha: 1)
        static let greenGradient = [UIColor(red: 0.71, green: 0.93, blue: 0.32, alpha: 1.0).cgColor,
                                    UIColor(red: 0.26, green: 0.58, blue: 0.13, alpha: 1.0).cgColor]
        static let blueGradient = [UIColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0).cgColor,
                                   UIColor(red: 0.00, green: 0.75, blue: 1.00, alpha: 1.0).cgColor]
        static let grayGradient = [UIColor(red: 0.40, green: 0.80, blue: 0.00, alpha: 1.0).cgColor,
                                   UIColor(red: 0.71, green: 0.93, blue: 0.32, alpha: 1.0).cgColor]
    }
    
    static let savingsInfoAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.black,
         NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 30)!]
}
