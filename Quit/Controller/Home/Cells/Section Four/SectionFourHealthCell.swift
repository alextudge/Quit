//
//  SectionFourHealthCell.swift
//  Quit
//
//  Created by Alex Tudge on 15/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class SectionFourHealthCell: UICollectionViewCell {

    @IBOutlet private weak var healthStateLabel: UILabel!
    @IBOutlet private weak var progressView: UIProgressView!
    
    var persistenceManager: PersistenceManager?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        progressView.trackTintColor = Styles.Colours.blueColor.withAlphaComponent(0.2)
        progressView.progressTintColor = Styles.Colours.blueColor
    }
    
    func setupCell(data: Constants.HealthStats) {
        guard let quitData = persistenceManager?.quitData,
            let minuteSmokeFree = quitData.minutesSmokeFree else {
            return
        }
        let time = data.secondsForHealthState() / 60
        let progress = Float(minuteSmokeFree / time)
        progressView.progress = progress < 1 ? progress : Float(1)
        healthStateLabel.text = data.rawValue
        healthStateLabel.textColor = .lightGray
    }
}
