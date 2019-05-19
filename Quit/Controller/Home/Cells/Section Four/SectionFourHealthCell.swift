//
//  SectionFourHealthCell.swift
//  Quit
//
//  Created by Alex Tudge on 15/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import Lottie

class SectionFourHealthCell: UICollectionViewCell {

    @IBOutlet private weak var healthStateLabel: UILabel!
    @IBOutlet private weak var progressLottieView: AnimationView!
    
    var persistenceManager: PersistenceManager?
    
    func setupCell(data: Constants.HealthStats) {
        guard let quitData = persistenceManager?.quitData,
            let minuteSmokeFree = quitData.minutesSmokeFree else {
            return
        }
        let time = data.secondsForHealthState() / 60
        let progress = Float(minuteSmokeFree / time)
        if progress > 1 {
            progressLottieView.animation = Animation.named("progressComplete")
            progressLottieView.play()
        } else {
            progressLottieView.animation = Animation.named("progressView")
            progressLottieView.play()
        }
        healthStateLabel.text = data.rawValue
        healthStateLabel.textColor = .lightGray
    }
}
