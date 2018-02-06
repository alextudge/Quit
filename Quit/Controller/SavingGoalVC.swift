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
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
     @IBAction func saveButtonPressed(_ sender: Any) {
        delegate?.addSavingGoal(title: goalTitleTextField.text!, cost: Double(goalCostTextField.text!)!)
        delegate?.isQuitDateSet()
        dismiss(animated: true, completion: nil)
    }
}

protocol savingGoalVCDelegate: class {
    func addSavingGoal(title: String, cost: Double)
    func isQuitDateSet()
}
