//
//  SectionOneVapingDataCell.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class SectionOneVapingDataCell: UICollectionViewCell {
    
    @IBOutlet weak var roundedView: RoundedView!
    @IBOutlet weak var vapeSpendLabel: UILabel!
    @IBOutlet weak var vapeSavingsLabel: UILabel!
    @IBOutlet weak var decreaseSpendingLabel: UIButton!
    
    var persistenceManager: PersistenceManager?
    private var gradientLayer: CAGradientLayer?

    weak var delegate: SectionOneCravingDataCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gradientLayer = roundedView.gradient(colors: Constants.Colours.blueGradient.reversed())
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = roundedView.bounds
        gradientLayer?.cornerRadius = roundedView.layer.cornerRadius
    }
    
    func setup() {
        let data = persistenceManager?.quitData
        if let amount = data?.vapeSpending {
            let amountString = stringFromCurrencyFormatter(data: NSNumber(value: amount))
            let savingAmountString = stringFromCurrencyFormatter(data: NSNumber(value: data?.vapingSavings ?? 0))
            vapeSpendLabel.text = "Your vape spend is \(amountString ?? "£0")"
            vapeSavingsLabel.text = amount > 0 ? "Compared to smoking, you've saved \(savingAmountString ?? "£0")" : ""
        } else {
            decreaseSpendingLabel.isHidden = true
            vapeSpendLabel.text = "You haven't registered any spending on vaping"
            vapeSavingsLabel.text = ""
        }
    }
    
    @IBAction func didTapIncreaseSpendingButton(_ sender: Any) {
        enterSpendAmountAlert(isIncreasing: true)
    }
    
    @IBAction func didTapDecreaseSpendingButton(_ sender: Any) {
        enterSpendAmountAlert(isIncreasing: false)
    }
    
    private func enterSpendAmountAlert(isIncreasing: Bool) {
        let alertController = UIAlertController(title: "Spend",
                                                message: "How much did you spend?",
                                                preferredStyle: .alert)
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
    
    private func alterVapeSpending(isIncreasing: Bool, amount: Double) {
        let quitData = persistenceManager?.quitData
        var newVapeSpending = 0.0
        if isIncreasing {
            newVapeSpending = (quitData?.vapeSpending ?? 0) + amount
        } else {
            newVapeSpending = (quitData?.vapeSpending ?? 0) - amount
        }
        newVapeSpending = newVapeSpending < 0 ? 0 : newVapeSpending
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
