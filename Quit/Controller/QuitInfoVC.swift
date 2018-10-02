//
//  QuitInfoVC.swift
//  Quit
//
//  Created by Alex Tudge on 04/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class QuitInfoVC: UIViewController, UITextFieldDelegate {
    
    weak var delegate: QuitDateSetVCDelegate?
    var persistenceManager: PersistenceManagerProtocol?
    var quitData: QuitData?
    var viewModel: QuitInfoVCViewModel?

    @IBOutlet weak var smokedDailyTextField: UITextField!
    @IBOutlet weak var costOf20TextField: UITextField!
    @IBOutlet weak var quitDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        
        viewModel = QuitInfoVCViewModel()
        smokedDailyTextField.delegate = self
        costOf20TextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if quitData != nil {
            self.costOf20TextField.text = "\(quitData?.costOf20 ?? 0)"
            self.smokedDailyTextField.text = "\(quitData?.smokedDaily ?? 0)"
            self.quitDatePicker.date = quitData?.quitDate ?? Date()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        smokedDailyTextField.resignFirstResponder()
        costOf20TextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func showDataMissingAlert() {
        
        let alert = UIAlertController(title: "Add all data!", message: "", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if costOf20TextField.text != "" && smokedDailyTextField.text != "" {
            guard let cost = Double(costOf20TextField.text!), let amount = Double(smokedDailyTextField.text!) else {
                showDataMissingAlert()
                return
            }
            let quitData: [String: Any] = ["smokedDaily": amount, "costOf20": cost, "quitDate": quitDatePicker.date]
            self.viewModel?.cancelAppleLocalNotifs()
            self.setLocalNotif()
            persistenceManager?.setQuitDataInUserDefaults(object: quitData, key: "quitData")
            delegate?.isQuitDateSet()
            dismiss(animated: true, completion: nil)
        } else {
            showDataMissingAlert()
            return
        }
    }
    
    func setLocalNotif() {
        
        for stat in Constants.healthStats {
            self.viewModel?.generateLocalNotif(title: stat.key,
                                               body: "Process complete!",
                                               minutes: Int(stat.value),
                                               datePicker: quitDatePicker.date)
        }
    }
}
