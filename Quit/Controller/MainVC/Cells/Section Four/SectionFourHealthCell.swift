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
    private var color = Styles.Colours.greenColour
    
    override func awakeFromNib() {
        super.awakeFromNib()
        color = randomColor()
        waveAnimationView.darkColor = color
        waveAnimationView.lightColor = color.withAlphaComponent(0.4)
        let randomNumber = Int.random(in: 20...40)
        waveAnimationView.heartAmplitude = Double(randomNumber)
    }
    
    func setupCell(data: Constants.HealthStats) {
        guard let quitData = persistenceManager?.quitData,
            let minuteSmokeFree = quitData.minuteSmokeFree else {
            return
        }
        let time = data.secondsForHealthState() / 60
        let progress = minuteSmokeFree / time
        waveAnimationView.progress = progress < 1 ? progress : 1
        waveAnimationView.heartAmplitude = 30
        healthStateLabel.text = data.rawValue
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
