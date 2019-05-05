//
//  SavingGoalVC.swift
//  Quit
//
//  Created by Alex Tudge on 06/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

protocol SavingGoalVCDelegate: class {
    func reloadTableView()
}

class SavingGoalVC: QuitBaseViewController {
    
    @IBOutlet private weak var goalTitleTextField: UITextField!
    @IBOutlet private weak var goalCostTextField: UITextField!
    @IBOutlet private weak var deleteButton: UIButton!
    
    var savingGoal: SavingGoal?
    
    weak var delegate: SavingGoalVCDelegate?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupUI()
    }
    
    private func setupDelegates() {
        goalTitleTextField.delegate = self
        goalCostTextField.delegate = self
    }
    
    private func setupUI() {
        goalCostTextField.addDoneButtonToKeyboard(action: #selector(goalCostTextField.resignFirstResponder))
        goalTitleTextField.addDoneButtonToKeyboard(action: #selector(goalTitleTextField.resignFirstResponder))
        if let savingGoal = savingGoal {
            deleteButton.isHidden = false
            goalTitleTextField.text = savingGoal.goalName
            goalCostTextField.text = "\(savingGoal.goalAmount)"
        } else {
            deleteButton.isHidden = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func showDataMissingAlert() {
        let alert = UIAlertController(title: "Add all data!", message: "", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    @IBAction private func saveButtonPressed(_ sender: Any) {
        if let goalTitle = goalTitleTextField.text?.capitalized,
            let goalCost = goalCostTextField.text,
            let cost = Double(goalCost) {
            if let savingGoal = savingGoal {
                savingGoal.goalAmount = cost
                savingGoal.goalName = goalTitle
                persistenceManager?.saveContext()
            } else {
                persistenceManager?.addSavingGoal(title: goalTitle, cost: cost)
            }
            delegate?.reloadTableView()
            navigationController?.popViewController(animated: true)
        } else {
            showDataMissingAlert()
        }
    }
    
    @IBAction private func deleteButtonPressed(_ sender: Any) {
        if let savingGoal = savingGoal {
            persistenceManager?.deleteSavingsGoal(savingGoal)
            delegate?.reloadTableView()
            navigationController?.popViewController(animated: true)
        }
    }
}

extension SavingGoalVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
