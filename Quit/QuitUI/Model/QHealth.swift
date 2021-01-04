//
//  QHealth.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import Foundation

enum QHealth: CaseIterable {
    case pulseNormal, oxygenLevels, nicotineRemoval, monoxideRemoval, nerveEndings, tasteAndSmell, bronchialTubes, oneWeekSuccess, lungPerformance, fertility, heartDisease, lungCancer
    
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
    
    var title: String {
        switch self {
        case .pulseNormal:
            return "Pulse normal"
        case .oxygenLevels:
            return "Oxygen levels normal"
        case .nicotineRemoval:
            return "Most nicotine removed"
        case .monoxideRemoval:
            return "All carbon monoxide removed from body"
        case .nerveEndings:
            return "Nerve endings start repairing"
        case .tasteAndSmell:
            return "Taste and smell start improving"
        case .bronchialTubes:
            return "Bronchial tubes relaxing"
        case .oneWeekSuccess:
            return "One week"
        case .lungPerformance:
            return "30% improvement in lung performance"
        case .fertility:
            return "Fertility and birth related issues reduced"
        case .heartDisease:
            return "Heart disease risk halved"
        case .lungCancer:
            return "Risk of lung cancer halved"
        }
    }
    
    func information() -> String {
        switch self {
        case .pulseNormal:
            return "Nicotine (found in cigarettes and most vape liquids) increases your heart rate and blood pressure.\n\nHigh blod pressure damages your arteries and your heart.\n\nWithin 20 minutes of your last cigarette, your heart rate and blood pressure return to normal levels."
        case .oxygenLevels:
            return "Carbon monoxide, found in smoke, reduces the amount of oxygen that your blood can carry around your body.\n\nThe increase in oxygen in the body after quitting reduces tiredness and the likelihood of headaches."
        case .nicotineRemoval:
            return "Nicotine is one of the most addictive chemicals around.\n\nIt can cause an increase in blood pressure, heart rate, flow of blood to the heart and a narrowing of the arteries. Nicotine also causes heart attacks by changing the structure of your arteries.\n\nIt stays in your body for six to eight hours after quitting. Whilst there are withdrawal symptoms, they are surprisingly weak given how addictive the substance is."
        case .monoxideRemoval:
            return "Carbon monoxide is a poisonous gas. When a cigarette burns it gives off carbon monoxide.\n\nWhen you smoke, carbon monoxide is absorbed through the lungs into the blood stream."
        case .nerveEndings, .tasteAndSmell:
            return "Smoking damages nerve endings in your nose and mouth, which limits your sense of taste and smell.\n\nWithin 2 days the nerve endings begin to regrow and your sense of taste and smell improve"
        case .bronchialTubes:
            return "Bronchial tubes are damaged and narrowed when you smoke, making it harder to breathe.\n\nSmoking narrows these tubes, and covers the small defensive hairs that line them with tar."
        case .oneWeekSuccess:
            return "You're nine times more likely to quit for good once you've reached the one week mark.\n\nWithdrawal symptoms will also be milder, and all of the improvements you've seen so far will continue growing."
        case .lungPerformance:
            return "At two weeks you should start to notice you're breathing easier. This is thanks to improved circulation and oxygenation.\n\nYour lung function increases as much as 30 percent about two weeks after quitting."
        case .fertility:
            return "Quitting can improve fertility, with some of the effects of smoking being reversed within a year of quitting.\n\nWomen who quit smoking within three months of pregnancy reduce the risk of their baby being born prematurely, often to the same level as non-smokers."
        case .heartDisease:
            return "The nicotine in smoke: reduces how much oxygen your heart gets, raises your blood pressure, speeds up your heart rate, makes blood clots more likely, which can lead to heart attacks or strokes, and harms the insides of your blood vessels, including those in your heart.\n\nAfter 1 year your risk of having a heart attack is half that of a smoker."
        case .lungCancer:
            return "Smoking can cause cancer almost anywhere in the body.\n\nYour risk of lung cancer is about half that of a person who is still smoking after 10 to 15 years. Your risk of cancer of the bladder, esophagus, and kidney also decreases."
        }
    }
}
