//
//  AchievementCell.swift
//  Quit
//
//  Created by Alex Tudge on 11/12/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class AchievementCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    func setupCell(data: Achievement) {
        if let title = data.title {
            titleLabel.text = title
        }
        if let result = data.result {
            resultLabel.text = "\(result)"
        }
        if data.succeded {
            resultLabel.textColor = .green
        }
    }
}
