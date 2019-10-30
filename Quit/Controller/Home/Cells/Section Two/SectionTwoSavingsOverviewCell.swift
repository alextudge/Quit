//
//  SectionTwoSavingsOverviewCell.swift
//  Quit
//
//  Created by Alex Tudge on 05/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import Lottie

protocol SectionTwoSavingsOverviewCellDelegate: class {
    func didTapAddSavingsGoalButton()
}

class SectionTwoSavingsOverviewCell: UICollectionViewCell {
    
    @IBOutlet private weak var savingsSummaryTextView: UITextView!
    @IBOutlet private weak var plusAnimationView: AnimationView!
    
    var persistenceManager: PersistenceManager?
    
    weak var delegate: SectionTwoSavingsOverviewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        plusAnimationView.play()
    }
    
    func setup() {
        savingsSummaryTextView.attributedText = savingsAttributedText(profile: persistenceManager?.getProfile())
        savingsSummaryTextView.backgroundColor = .clear
        savingsSummaryTextView.isEditable = false
        savingsSummaryTextView.isSelectable = false
        savingsSummaryTextView.layoutIfNeeded()
    }
    
    @IBAction private func addSavingGoalButton(_ sender: Any) {
        delegate?.didTapAddSavingsGoalButton()
    }
}

private extension SectionTwoSavingsOverviewCell {
    func savingsAttributedText(profile: Profile?) -> NSAttributedString? {
        guard let costPerDay = profile?.costPerDay as NSNumber?,
            let costPerYear = profile?.costPerYear as NSNumber?,
            let savedSoFar = profile?.savedSoFar as NSNumber? else {
                return nil
        }
        var text = NSAttributedString()
        if let dailyCost = stringFromCurrencyFormatter(data: costPerDay.doubleValue),
            let annualCost = stringFromCurrencyFormatter(data: costPerYear.intValue),
            let soFar = stringFromCurrencyFormatter(data: savedSoFar.intValue),
            let lifetime = stringFromCurrencyFormatter(data: costPerYear.intValue * 70) {
            if quitDateIsInPast(profile: persistenceManager?.getProfile()) {
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
    
    func stringFromCurrencyFormatter(data: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: data))
    }
    
    func stringFromCurrencyFormatter(data: Int) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: data))
    }
    
     func quitDateIsInPast(profile: Profile?) -> Bool {
        guard let quitDate = profile?.quitDate else {
            return false
        }
        return quitDate < Date()
    }
}
