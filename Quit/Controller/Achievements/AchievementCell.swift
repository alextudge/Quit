//
//  AchievementCell.swift
//  Quit
//
//  Created by Alex Tudge on 11/12/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class AchievementCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var resultLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resultLabel.alpha = 1
    }
    
    func setupCell(data: QuitAchievements, profile: Profile?) {
        guard let profile = profile else {
            return
        }
        titleLabel.text = data.titleForAchievement()
        resultLabel.text = data.resultsText(profile: profile).resultstext
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.resultLabel.alpha = data.resultsText(profile: profile).passed ? 1 : 0
        })
    }
}
