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
    private var color = Constants.Colours.greenColour
    
    override func awakeFromNib() {
        super.awakeFromNib()
        color = randomColor()
        waveAnimationView.heavyHeartColor = color
        waveAnimationView.lightHeartColor = color.withAlphaComponent(0.4)
        let randomNumber = Int.random(in: 20...40)
        waveAnimationView.heartAmplitude = Double(randomNumber)
    }
    
    func setupCell(data: String) {
        guard let quitData = persistenceManager?.getQuitDataFromUserDefaults(),
            let minuteSmokeFree = quitData.minuteSmokeFree else {
            return
        }
        let time = secondsForHealthState(healthStat: data) / 60
        let progress = minuteSmokeFree / time
        waveAnimationView.progress = progress < 1 ? progress : 1
        waveAnimationView.heartAmplitude = 30
        healthStateLabel.text = data
        if progress > 0.2 {
            healthStateLabel.textColor = .white
        } else {
            healthStateLabel.textColor = color
        }
    }
    
    private func randomColor() -> UIColor {
        let randomRed: CGFloat = CGFloat(drand48())
        let randomGreen: CGFloat = CGFloat(drand48())
        let randomBlue: CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}