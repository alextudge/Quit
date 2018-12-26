//
//  SectionTwoSavingsOverviewCell.swift
//  Quit
//
//  Created by Alex Tudge on 05/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

protocol SectionTwoSavingsOverviewCellDelegate: class {
    func didTapAddSavingsGoalButton()
}

class SectionTwoSavingsOverviewCell: UICollectionViewCell {
    
    @IBOutlet weak var savingsSummaryTextView: UITextView!
    
    var persistenceManager: PersistenceManager?
    
    weak var delegate: SectionTwoSavingsOverviewCellDelegate?
    
    func setup() {
        savingsSummaryTextView.attributedText = savingsAttributedText(quitData: persistenceManager?.quitData)
        savingsSummaryTextView.backgroundColor = .clear
        savingsSummaryTextView.isEditable = false
        savingsSummaryTextView.isSelectable = false
    }
    
    private func savingsAttributedText(quitData: QuitData?) -> NSAttributedString? {
        guard let costPerDay = quitData?.costPerDay as NSNumber?,
            let costPerYear = quitData?.costPerYear as NSNumber?,
            let savedSoFar = quitData?.savedSoFar as NSNumber? else {
                return nil
        }        
        var text = NSAttributedString()
        if let dailyCost = stringFromCurrencyFormatter(data: costPerDay),
            let annualCost = stringFromCurrencyFormatter(data: costPerYear),
            let soFar = stringFromCurrencyFormatter(data: savedSoFar) {
            if quitDateIsInPast(quitData: persistenceManager?.quitData) {
                text = NSAttributedString(
                    string: "\(dailyCost) saved daily, \(annualCost) saved yearly. \(soFar) saved so far.",
                    attributes: Constants.savingsInfoAttributes)
            } else {
                text = NSAttributedString(string: "You'll save \(dailyCost) daily and \(annualCost) yearly.",
                    attributes: Constants.savingsInfoAttributes)
            }
        }
        return text
    }
    
    private func stringFromCurrencyFormatter(data: NSNumber) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: data)
    }
    
    private func quitDateIsInPast(quitData: QuitData?) -> Bool {
        guard let quitDate = quitData?.quitDate else {
            return false
        }
        return quitDate < Date()
    }
    
    @IBAction func addSavingGoalButton(_ sender: Any) {
        delegate?.didTapAddSavingsGoalButton()
    }
}
