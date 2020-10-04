//
//  SectionThreeCravingsChartCell.swift
//  Quit
//
//  Created by Alex Tudge on 06/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

protocol SectionThreeCravingsChartCellDelegate: class {
    func didTapCravingsDetailButton()
}

class SectionThreeCravingsChartCell: UICollectionViewCell {
    
    @IBOutlet private weak var roundedView: RoundedView!
    
    weak var delegate: SectionThreeCravingsChartCellDelegate?
    
    private var persistenceManager: PersistenceManager?
    
    @IBAction private func didTapCravingsDetailButton(_ sender: Any) {
        delegate?.didTapCravingsDetailButton()
    }
}

private extension SectionThreeCravingsChartCell {
    
    func standardisedDate(date: Date) -> Date {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        let stringDate = formatter.string(from: date)
        return formatter.date(from: stringDate)!
    }
    
    func mediumDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}
