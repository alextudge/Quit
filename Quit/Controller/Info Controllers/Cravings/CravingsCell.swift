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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        triggerLabel.text = ""
    }
    
    func setup(_ craving: Craving) {
        let formatter = mediumDateFormatter()
        if let date = craving.cravingDate {
            dateLabel.text = formatter.string(from: date)
        }
        triggerLabel.text = craving.cravingCatagory?.isEmpty == true ? "No trigger" : craving.cravingCatagory
        backgroundColor = craving.cravingSmoked ? UIColor.orange.withAlphaComponent(0.1) : .clear
    }
    
    func mediumDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}
