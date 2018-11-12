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
}

class QuitInfoVC: UIViewController {
    
    @IBOutlet private weak var smokedDailyTextField: UITextField!
    @IBOutlet private weak var costOf20TextField: UITextField!
    @IBOutlet private weak var quitDatePicker: UIDatePicker!
    
    weak var delegate: QuitDateSetVCDelegate?
    
    var persistenceManager: PersistenceManager?
    private let viewModel = QuitInfoVCViewModel()
    private var quitData: QuitData? {
        return persistenceManager?.getQuitDataFromUserDefaults()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        if let costOf20 = quitData?.costOf20 {
            costOf20TextField.text = "\(costOf20)"
        }
        if let smokedDaily = quitData?.smokedDaily {
            smokedDailyTextField.text = "\(smokedDaily)"
        }
        quitDatePicker.date = quitData?.quitDate ?? Date()
    }
    
    private func showDataMissingAlert() {
        let alert = UIAlertController(title: "Complete data",
                                      message: "We need all of this data to set you up (you can change it at any time)!",
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction private func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
        setNotifications()
        delegate?.reloadTableView()
        dismiss(animated: true, completion: nil)
    }
    
    func setNotifications() {
        viewModel.cancelAppleLocalNotifs()
        for stat in Constants.healthStats {
            self.viewModel.generateLocalNotif(title: stat,
                                               body: "Process complete!",
                                               minutes: secondsForHealthState(healthStat: stat),
                                               datePicker: quitDatePicker.date)
        }
    }
}

extension QuitInfoVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
