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
    @IBOutlet weak var deleteButton: UIButton!
    weak var delegate: savingGoalVCDelegate?
    var savingGoal: SavingGoal? = nil
    var persistenceManager: PersistenceManager? = nil
    
    override func viewDidLoad() {
        goalTitleTextField.delegate = self
        goalCostTextField.delegate = self
        if self.savingGoal != nil {
            self.deleteButton.isEnabled = true
            self.goalTitleTextField.text = savingGoal?.goalName
            self.goalCostTextField.text = "\(savingGoal!.goalAmount)"
        } else {
            self.deleteButton.isEnabled = false
            self.deleteButton.backgroundColor = .lightGray
        }
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
            if self.savingGoal == nil {
                persistenceManager?.addSavingGoal(title: goalTitleTextField.text!, cost: cost)
                delegate?.setupSection2()
                dismiss(animated: true, completion: nil)
            } else {
                savingGoal!.goalAmount = cost
                savingGoal!.goalName = goalTitleTextField.text!
                delegate?.setupSection2()
                dismiss(animated: true, completion: nil)
            }
        } else {
            showDataMissingAlert()
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        if savingGoal != nil {
            persistenceManager?.deleteObject(object: savingGoal!)
            delegate?.setupSection2()
            self.dismiss(animated: true, completion: nil)
        }
    }
}

protocol savingGoalVCDelegate: class {
    func setupSection2()
}
