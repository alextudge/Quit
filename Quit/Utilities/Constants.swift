//
//  Constants.swift
//  Quit
//
//  Created by Alex Tudge on 18/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

struct Constants {
    
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
    }
    
    struct Cells {
        static let sectionOneCarouselCell = "SectionOneCarouselCell"
        static let sectionTwoCarouselCell = "SectionTwoCarouselCell"
        static let sectionThreeCarouselCell = "SectionThreeCarouselCell"
        static let sectionFourCarouselCell = "SectionFourCarouselCell"
    }
    
    static let healthStats: [String] =
        ["Correcting blood pressure",
         "Normalising heart rate",
         "Nicotine down to 90%",
         "Raising blood oxygen levels to normal",
         "Normalising carbon monoxide levels",
         "Started removing lung debris",
         "Starting to repair nerve endings",
         "Correcting smell and taste",
         "Removing all nicotine",
         "Improving lung performance",
         "Worst withdrawal symptoms over",
         "Fixing mouth and gum circulation",
         "Emotional trauma ended",
         "Halving heart attack risk"]
    
    struct Colours {
        static let greenColour = UIColor(red: 102/255, green: 204/255, blue: 150/255, alpha: 1)
    }
    
    static let savingsInfoAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.white,
         NSAttributedString.Key.backgroundColor: UIColor.black,
         NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 30)!]
}
