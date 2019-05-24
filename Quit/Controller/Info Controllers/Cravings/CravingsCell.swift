//
//  CravingsCell.swift
//  Quit
//
//  Created by Alex Tudge on 05/05/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import UIKit

class CravingsCell: UITableViewCell {
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var triggerLabel: UILabel!
    
    func setup(_ craving: Craving) {
        let formatter = mediumDateFormatter()
        if let date = craving.cravingDate {
            dateLabel.text = formatter.string(from: date)
        }
        triggerLabel.text = craving.cravingCatagory
    }
    
    func mediumDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}
