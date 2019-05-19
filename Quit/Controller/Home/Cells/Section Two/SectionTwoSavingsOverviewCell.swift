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
        if let dailyCost = stringFromCurrencyFormatter(data: costPerDay.doubleValue),
            let annualCost = stringFromCurrencyFormatter(data: costPerYear.intValue),
            let soFar = stringFromCurrencyFormatter(data: savedSoFar.intValue),
            let lifetime = stringFromCurrencyFormatter(data: costPerYear.intValue * 70) {
            if quitDateIsInPast(quitData: persistenceManager?.quitData) {
                text = NSAttributedString(
                    string: "\(soFar) so far\n\(dailyCost) daily\n\(annualCost) yearly\n\(lifetime) over a lifetime",
                    attributes: Styles.savingsInfoAttributes)
            } else {
                text = NSAttributedString(string: "You'll save \(dailyCost) daily and \(annualCost) yearly.",
                    attributes: Styles.savingsInfoAttributes)
            }
        }
        return text
    }
    
    private func stringFromCurrencyFormatter(data: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: data))
    }
    
    private func stringFromCurrencyFormatter(data: Int) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: data))
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