//
//  QuitInfoCostCell.swift
//  Quit
//
//  Created by Alex Tudge on 08/11/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import UIKit

protocol QuitInfoCostCellDelegate: class {
    func goToNextPage()
    func presentAlert(title: String, message: String)
}

class QuitInfoCostCell: UICollectionViewCell, QuitBaseCellProtocol {
        
    @IBOutlet private weak var costOf20TextField: UITextField!
    @IBOutlet private weak var smokedDailyTextField: UITextField!
    
    var persistenceManager: PersistenceManager?
    
    weak var delegate: QuitInfoCostCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupDelegates()
    }
    
    func setup(persistenceManager: PersistenceManager?) {
        self.persistenceManager = persistenceManager
        populateTextFields()
    }
    
    @IBAction private func didTapNextButton(_ sender: Any) {
        if isDataValid() {
            persistValues()
            delegate?.goToNextPage()
        } else {
            delegate?.presentAlert(title: "😅", message: "We need this information to set up the app for you!")
        }
    }
}

extension QuitInfoCostCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        return string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

private extension QuitInfoCostCell {
    func setupDelegates() {
        costOf20TextField.delegate = self
        smokedDailyTextField.delegate = self
    }
    
    func populateTextFields() {
        if let costOf20 = persistenceManager?.getProfile()?.costOf20?.intValue {
            costOf20TextField.text = "\(costOf20)"
        }
        if let smokedDaily = persistenceManager?.getProfile()?.smokedDaily?.intValue {
            smokedDailyTextField.text = "\(smokedDaily)"
        }
    }
    
    func isDataValid() -> Bool {
        return costOf20TextField.text?.isEmpty == false && smokedDailyTextField.text?.isEmpty == false
    }
    
    func persistValues() {
        guard let persistenceManager = persistenceManager,
            let profile = persistenceManager.getProfile(),
            let smokedDaily = Int(smokedDailyTextField.text ?? "0"),
            let costOf20 = Int(costOf20TextField.text ?? "0") else {
                return
        }
        profile.costOf20 = NSNumber(value: costOf20)
        profile.smokedDaily = NSNumber(value: smokedDaily)
        persistenceManager.saveContext()
    }
}
