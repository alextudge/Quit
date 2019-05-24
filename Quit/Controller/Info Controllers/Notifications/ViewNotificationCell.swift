//
//  ViewNotificationCell.swift
//  Quit
//
//  Created by Alex Tudge on 24/05/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import UIKit

class ViewNotificationCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    func setupCell(title: String?, body: String?, date: Date?) {
        titleLabel.text = title
        bodyLabel.text = body
        if let date = date {
            dateLabel.text = formatDate(date: date)
        }
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM"
        return dateFormatter.string(from: date)
    }
}
