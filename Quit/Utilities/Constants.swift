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
        static let adFreeExpirationDate = "AdFreeExpirationDate"
    }
    
    struct CoreData {
        static let craving = "Craving"
        static let savingGoal = "SavingGoal"
        static let profile = "Profile"
        static let coreDataObjects = [craving, savingGoal]
        static let databaseId = "Quit.sqlite"
    }
    
    struct ProfileConstants {
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
        static let healthProgress = "HealthAchievementNotification"
    }
}

struct Styles {
    static let savingsInfoAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.label,
         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)]
}
