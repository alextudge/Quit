//
//  SectionFourHealthCell.swift
//  Quit
//
//  Created by Alex Tudge on 15/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class SectionFourHealthCell: UICollectionViewCell {

    @IBOutlet weak var waveAnimationView: WaveAnimationView!
    @IBOutlet weak var healthStateLabel: UILabel!
    
    var persistenceManager: PersistenceManager?
    
    func setupCell(data: String) {
        let time = secondsForHealthState(healthStat: data)
        let quitData = persistenceManager?.getQuitDataFromUserDefaults()
        let progress = quitData?.minuteSmokeFree ?? 0 / time
        healthStateLabel.text = data
        waveAnimationView.progress = progress < 1 ? progress : 1
        waveAnimationView.heartAmplitude = 30
        let randomNumber = Int.random(in: 20...40)
        waveAnimationView.heartAmplitude = Double(randomNumber)
        if progress > 0.2 {
            healthStateLabel.textColor = .white
        } else {
            healthStateLabel.textColor = UIColor(red: 254/255.0, green: 102/255.0, blue: 131/255.0, alpha: 1.0)
        }
    }
    
    func secondsForHealthState(healthStat: String) -> Double {
        switch healthStat {
        case "Correcting blood pressure":
            return 20
        case "Normalising heart rate":
            return 20
        case "Nicotine down to 90%":
            return 480
        case "Raising blood oxygen levels to normal":
            return 480
        case "Normalising carbon monoxide levels":
            return 720
        case "Started removing lung debris":
            return 1440
        case "Starting to repair nerve endings":
            return 2880
        case "Correcting smell and taste":
            return 2880
        case "Removing all nicotine":
            return 4320
        case "Improving lung performance":
            return 4320
        case "Worst withdrawal symptoms over":
            return 4320
        case "Fixing mouth and gum circulation":
            return 14400
        case "Emotional trauma ended":
            return 21600
        case "Halving heart attack risk":
            return 525600
        default:
            return 0
        }
    }
}
