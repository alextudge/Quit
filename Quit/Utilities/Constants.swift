//
//  Constants.swift
//  Quit
//
//  Created by Alex Tudge on 18/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

struct Constants {
    
   static let healthStats: [String: Double] =
    ["Correcting blood pressure": 20,
     "Normalising heart rate": 20,
     "Nicotine down to 90%": 480,
     "Raising blood oxygen levels to normal": 480,
     "Normalising carbon monoxide levels": 720,
     "Started removing lung debris": 1440,
     "Starting to repair nerve endings": 2880,
     "Correcting smell and taste": 2880,
     "Removing all nicotine": 4320,
     "Improving lung performance": 4320,
     "Worst withdrawal symptoms over": 4320,
     "Fixing mouth and gum circulation": 14400,
     "Emotional trauma ended": 21600,
     "Halving heart attack risk": 525600]
    
    static let greenColour = UIColor(red: 102/255, green: 204/255, blue: 150/255, alpha: 1)
    
    static let savingsInfoAttributes =
        [NSAttributedStringKey.foregroundColor: UIColor.white,
         NSAttributedStringKey.backgroundColor: UIColor.black,
         NSAttributedStringKey.font: UIFont(name: "AvenirNext-Bold", size: 30)!]
    
    static let achieved = [NSAttributedStringKey.foregroundColor: UIColor(red: 102/255,
                                                                          green: 204/255,
                                                                          blue: 150/255,
                                                                          alpha: 1),
                                       NSAttributedStringKey.font: UIFont(name: "AvenirNext-Bold", size: 30)!]
    
    static let notAchieved = [NSAttributedStringKey.foregroundColor: UIColor.gray,
                                      NSAttributedStringKey.font: UIFont(name: "AvenirNext-Bold", size: 30)!]
}
