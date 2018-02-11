//
//  SavingGoalVC.swift
//  Quit
//
//  Created by Alex Tudge on 06/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class SavingGoalVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var goalTitleTextField: UITextField!
    @IBOutlet weak var goalCostTextField: UITextField!
    weak var delegate: savingGoalVCDelegate?
    
    override func viewDidLoad() {
        goalTitleTextField.delegate = self
        goalCostTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        goalCostTextField.resignFirstResponder()
        goalTitleTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func showDataMissingAlert() {
        let alert = UIAlertController(title: "Add all data!", message: "", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if goalTitleTextField.text != "" && goalCostTextField.text != "" {
            guard let cost = Double(goalCostTextField.text!) else {
                showDataMissingAlert()
                return
            }
            delegate?.addSavingGoal(title: goalTitleTextField.text!, cost: cost)
            delegate?.isQuitDateSet()
            dismiss(animated: true, completion: nil)
        } else {
            showDataMissingAlert()
        }
    }
}

protocol savingGoalVCDelegate: class {
    func addSavingGoal(title: String, cost: Double)
    func isQuitDateSet()
}
