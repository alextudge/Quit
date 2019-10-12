//
//  QuitCostViewController.swift
//  Quit
//
//  Created by Alex Tudge on 12/10/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import UIKit

class QuitCostViewController: QuitBaseViewController {

    @IBOutlet private weak var costOf20TextField: UITextField!
    @IBOutlet private weak var smokedDailyTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        populateTextFields()
    }
    
    @IBAction private func didTapNextButton(_ sender: Any) {
        if isDataValid() {
            persistValues()
            (parent as? QuitInfoPageViewController)?.goToNextPage()
        } else {
            presentAlert(title: "😅", message: "We need this information to set up the app for you!")
        }
    }
}

extension QuitCostViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        return string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

private extension QuitCostViewController {
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
