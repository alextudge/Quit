//
//  SectionOneVapingDataCell.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class SectionOneVapingDataCell: UICollectionViewCell {
    
    @IBOutlet private weak var vapeSpendLabel: UILabel!
    @IBOutlet private weak var vapeSavingsLabel: UILabel!
    @IBOutlet private weak var decreaseSpendingLabel: UIButton!
    
    var persistenceManager: PersistenceManager?

    weak var delegate: SectionOneCellsDelegate?
    
    func setup() {
        let data = persistenceManager?.getProfile()
        if let amount = data?.vapeSpending {
            decreaseSpendingLabel.isHidden = false
            let amountString = stringFromCurrencyFormatter(data: amount)
            let savingAmountString = stringFromCurrencyFormatter(data: NSNumber(value: data?.vapingSavings ?? 0))
            vapeSpendLabel.text = "Your vape spend is \(amountString ?? "£0")"
            if amount.doubleValue > 0 {
                vapeSavingsLabel.isHidden = false
                vapeSavingsLabel.text = "Compared to smoking, you've saved \(savingAmountString ?? "£0")"
            } else {
                vapeSavingsLabel.isHidden = true
            }
        } else {
            decreaseSpendingLabel.isHidden = true
            vapeSpendLabel.text = "You haven't registered any spending on vaping"
            vapeSavingsLabel.text = ""
        }
        layoutIfNeeded()
    }
    
    @IBAction private func didTapIncreaseSpendingButton(_ sender: Any) {
        enterSpendAmountAlert(isIncreasing: true)
    }
    
    @IBAction private func didTapDecreaseSpendingButton(_ sender: Any) {
        enterSpendAmountAlert(isIncreasing: false)
    }
}

private extension SectionOneVapingDataCell {
    func enterSpendAmountAlert(isIncreasing: Bool) {
        let alertController = UIAlertController(title: "Spend", message: "How much did you spend?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Save", style: .default) { _ in
            let textField = alertController.textFields![0] as UITextField
            guard let textAmount = textField.text,
                let numericalAmount = Double(textAmount) else {
                    return
            }
            self.alterVapeSpending(isIncreasing: isIncreasing, amount: numericalAmount)
        }
        alertController.addAction(yesAction)
        let noAction = UIAlertAction(title: "Cancel", style: .destructive)
        alertController.addAction(noAction)
        alertController.addTextField { (textField) in
            textField.placeholder = "Spend value"
            textField.keyboardType = .numberPad
        }
        delegate?.presentAlert(alertController)
    }
    
    func alterVapeSpending(isIncreasing: Bool, amount: Double) {
        let profile = persistenceManager?.getProfile()
        var newVapeSpending = 0.0
        if isIncreasing {
            newVapeSpending = (profile?.vapeSpending?.doubleValue ?? 0) + amount
        } else {
            newVapeSpending = (profile?.vapeSpending?.doubleValue ?? 0) - amount
        }
        newVapeSpending = newVapeSpending < 0 ? 0 : newVapeSpending
        persistenceManager?.getProfile()?.vapeSpending = NSNumber(value: newVapeSpending)
        persistenceManager?.saveContext()
        setup()
    }
    
    func stringFromCurrencyFormatter(data: NSNumber) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: data)
    }
}
