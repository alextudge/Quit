//
//  SectionOneVapingDataCell.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class SectionOneVapingDataCell: UICollectionViewCell {
    
    var persistenceManager: PersistenceManager?
    
    @IBOutlet weak var vapeSpendLabel: UILabel!
    @IBOutlet weak var vapeSavingsLabel: UILabel!
    @IBOutlet weak var decreaseSpendingLabel: UIButton!
    
    func setup() {
        let data = persistenceManager?.getQuitDataFromUserDefaults()
        if let amount = data?.vapeSpending {
            let amountString = stringFromCurrencyFormatter(data: NSNumber(value: amount))
            let savingAmountString = stringFromCurrencyFormatter(data: NSNumber(value: data?.vapingSavings ?? 0))
            vapeSpendLabel.text = "Your vape spend is \(amountString ?? "£0")"
            vapeSavingsLabel.text = amount > 0 ? "Compared to smoking, you've saved \(savingAmountString ?? "£0")" : ""
        } else {
            decreaseSpendingLabel.isHidden = true
            vapeSpendLabel.text = "You haven't registered any spending on vaping"
            vapeSpendLabel.text = ""
        }
    }
    
    @IBAction func didTapIncreaseSpendingButton(_ sender: Any) {
        alterVapeSpending()
    }
    
    @IBAction func didTapDecreaseSpendingButton(_ sender: Any) {
        alterVapeSpending(isIncreasing: false)
    }
    
    private func alterVapeSpending(isIncreasing: Bool = true) {
        let quitData = persistenceManager?.getQuitDataFromUserDefaults()
        var newVapeSpending = 0.0
        if isIncreasing {
            newVapeSpending = (quitData?.vapeSpending ?? 0) + 10.0
        } else {
            newVapeSpending = (quitData?.vapeSpending ?? 0) - 10.0
        }
        let newQuitData: [String: Any] = [Constants.QuitDataConstants.smokedDaily: quitData?.smokedDaily,
                                          Constants.QuitDataConstants.costOf20: quitData?.costOf20,
                                          Constants.QuitDataConstants.quitDate: quitData?.quitDate,
                                          Constants.QuitDataConstants.vapeSpending: newVapeSpending]
        persistenceManager?.setQuitDataInUserDefaults(object: newQuitData, key: "quitData")
        setup()
    }
    
    private func stringFromCurrencyFormatter(data: NSNumber) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: data)
    }
}
