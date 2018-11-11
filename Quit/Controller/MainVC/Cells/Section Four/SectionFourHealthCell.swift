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
}
