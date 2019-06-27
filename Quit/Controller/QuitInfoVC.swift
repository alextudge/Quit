//
//  QuitInfoVC.swift
//  Quit
//
//  Created by Alex Tudge on 04/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

protocol QuitInfoVCDelegate: class {
    func didUpdateQuitData()
}

class QuitInfoVC: QuitBaseViewController {
     
    @IBOutlet private weak var smokedDailyTextField: UITextField!
    @IBOutlet private weak var costOf20TextField: UITextField!
    @IBOutlet private weak var quitDatePicker: UIDatePicker!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    
    private let viewModel = QuitInfoVCViewModel()
    
    weak var delegate: QuitInfoVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialValues(quitData)
        setupDelegates()
        setupObservers()
        setupUI()
    }
    
    @IBAction private func pickerViewDidChange(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction private func saveButtonPressed(_ sender: Any) {
        guard let costOf20Text = costOf20TextField.text,
            costOf20Text != "",
            let smokedDaily = smokedDailyTextField.text,
            smokedDaily != "",
            let cost = Double(costOf20Text),
            let amount = Double(smokedDaily) else {
                showDataMissingAlert()
                return
        }
        let quitData: [String: Any] = [Constants.QuitDataConstants.smokedDaily: amount,
                                       Constants.QuitDataConstants.costOf20: cost,
                                       Constants.QuitDataConstants.quitDate: quitDatePicker.date]
        persistenceManager?.setQuitDataInUserDefaults(object: quitData, key: "quitData")
        setNotifications(quitDate: quitDatePicker.date)
        NotificationCenter.default.post(name: Constants.InternalNotifs.quitDateChanged, object: nil)
        delegate?.didUpdateQuitData()
        dismiss(animated: true, completion: nil)
    }
}

private extension QuitInfoVC {
    func setupDelegates() {
        smokedDailyTextField.delegate = self
        costOf20TextField.delegate = self
    }
    
    func setupUI() {
        title = "Your Quit"
        smokedDailyTextField.addDoneButtonToKeyboard(action: #selector(smokedDailyTextField.resignFirstResponder))
        costOf20TextField.addDoneButtonToKeyboard(action: #selector(costOf20TextField.resignFirstResponder))
    }
    
    func setupInitialValues(_ quitData: QuitData?) {
        if let costOf20 = quitData?.costOf20 {
            costOf20TextField.text = "\(costOf20)"
        }
        if let smokedDaily = quitData?.smokedDaily {
            smokedDailyTextField.text = "\(smokedDaily)"
        }
        quitDatePicker.date = quitData?.quitDate ?? Date()
    }
    
    func setNotifications(quitDate: Date) {
        viewModel.cancelAppleLocalNotifs()
        viewModel.generateLocalNotif(quitDate: quitDate)
    }
    
    func showDataMissingAlert() {
        presentAlert(title: "We need all of this information",
                     message: "We need all of this data to set you up (you can change it at any time)!")
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
        }
        let keyboardFrame = keyboardSize.cgRectValue
        if bottomConstraint.constant == 20 {
            changeBottomConstraint(to: keyboardFrame.height + 10)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if bottomConstraint.constant != 0 {
            changeBottomConstraint(to: 20)
        }
    }
    
    func changeBottomConstraint(to height: CGFloat) {
        UIView.animate(withDuration: 0.25, animations: {
            self.bottomConstraint.constant = height
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension QuitInfoVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
