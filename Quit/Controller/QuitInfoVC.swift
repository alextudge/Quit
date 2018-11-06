//
//  QuitInfoVC.swift
//  Quit
//
//  Created by Alex Tudge on 04/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

protocol QuitDateSetVCDelegate: class {
    func reloadTableView()
    func resetQuitData()
}

class QuitInfoVC: UIViewController {
    
    private let viewModel = QuitInfoVCViewModel()
    var persistenceManager: PersistenceManagerProtocol?
    var quitData: QuitData?
    
    weak var delegate: QuitDateSetVCDelegate?

    @IBOutlet private weak var smokedDailyTextField: UITextField!
    @IBOutlet private weak var costOf20TextField: UITextField!
    @IBOutlet private weak var quitDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        setupDelegates()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupInitialValues(quitData)
    }
    
    private func setupDelegates() {
        smokedDailyTextField.delegate = self
        costOf20TextField.delegate = self
    }
    
    private func setupUI() {
        quitDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
    }
    
    private func setupInitialValues(_ quitData: QuitData?) {
        costOf20TextField.text = "\(quitData?.costOf20 ?? 0)"
        smokedDailyTextField.text = "\(quitData?.smokedDaily ?? 0)"
        quitDatePicker.date = quitData?.quitDate ?? Date()
    }
    
    private func showDataMissingAlert() {
        let alert = UIAlertController(title: "Complete data", message: "We need all of this data to set you up (you can change it at any time)!", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        smokedDailyTextField.resignFirstResponder()
        costOf20TextField.resignFirstResponder()
        view.endEditing(true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard costOf20TextField.text != "" &&
            smokedDailyTextField.text != "",
            let cost = Double(costOf20TextField.text!),
            let amount = Double(smokedDailyTextField.text!) else {
                showDataMissingAlert()
                return
        }
        let quitData: [String: Any] = [Constants.QuitDataConstants.smokedDaily: amount,
                                       Constants.QuitDataConstants.costOf20: cost,
                                       Constants.QuitDataConstants.quitDate: quitDatePicker.date]
        persistenceManager?.setQuitDataInUserDefaults(object: quitData, key: "quitData")
        setNotifications()
        delegate?.resetQuitData()
        delegate?.reloadTableView()
        dismiss(animated: true, completion: nil)
    }
    
    func setNotifications() {
        viewModel.cancelAppleLocalNotifs()
        for stat in Constants.healthStats {
//            self.viewModel?.generateLocalNotif(title: stat.key,
//                                               body: "Process complete!",
//                                               minutes: Int(stat.value),
//                                               datePicker: quitDatePicker.date)
        }
    }
}

extension QuitInfoVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
