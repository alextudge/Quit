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
        static let adBannerId = "ca-app-pub-9559625170509646/6744087773"
        static let adInterstitialId = "ca-app-pub-9559625170509646/6049646681"
    }
    
    struct UserDefaults {
        static let quitData = "quitData"
        static let additionalUserData = "additionalUserData"
        static let appLoadCount = "appLoadCount"
        static let reasonsOnboardingSeen = "reasonsOnboardingSeen"
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
    
    struct AdditionalUserDataConstants {
        static let reasonsToSmoke = "reasonsToSmoke"
        static let reasonsNotToSmoke = "reasonsNotToSmoke"
    }
    
    struct Cells {
        static let sectionOneCarouselCell = "SectionOneCarouselCell"
        static let sectionOneCravingDataCell = "SectionOneCravingDataCell"
        static let sectionOneVapingDataCell = "SectionOneVapingDataCell"
        static let sectionTwoCarouselCell = "SectionTwoCarouselCell"
        static let sectionThreeCarouselCell = "SectionThreeCarouselCell"
        static let sectionFourCarouselCell = "SectionFourCarouselCell"
        static let sectionFiveCarouselCell = "SectionFiveCarouselCell"
        static let sectionFiveReasonsToSmokeCell = "SectionFiveReasonsToSmokeCell"
        static let sectionFiveReasonsNotToSmokeCell = "SectionFiveReasonsNotToSmokeCell"
        static let achievementCell = "achievementCell"
    }
    
    struct InternalNotifs {
        static let cravingsChanged = NSNotification.Name("cravingsChanged")
        static let savingsChanged = NSNotification.Name("savingsChanged")
        static let quitDateChanged = NSNotification.Name("quitDateChanged")
        static let additionalDataUpdated = NSNotification.Name("additionalDataUpdated")
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
        static let blueColor = UIColor(named: "blueColour") ?? .blue
        static let greenColour = UIColor(named: "greenColour") ?? .green
    }
    
    static let savingsInfoAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel,
         NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 30)!]
}
