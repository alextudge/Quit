//
//  QuitInfoVC.swift
//  Quit
//
//  Created by Alex Tudge on 04/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class QuitInfoVC: UIViewController, UITextFieldDelegate {
    
    weak var delegate: QuitVCDelegate?
    let defaults = UserDefaults.standard

    @IBOutlet weak var cigarettesSmokedDaily: UITextField!
    @IBOutlet weak var costOf20: UITextField!
    @IBOutlet weak var quitDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        cigarettesSmokedDaily.delegate = self
        costOf20.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        cigarettesSmokedDaily.resignFirstResponder()
        costOf20.resignFirstResponder()
        self.view.endEditing(true)
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        let quitData: [String: Any] = ["smokedDaily": Int(cigarettesSmokedDaily.text!), "costOf20": Int(costOf20.text!), "quitDate": quitDatePicker.date]
        defaults.set(quitData, forKey: "quitData")
        delegate?.isQuitDateSet()
        dismiss(animated: true, completion: nil)
    }
}

protocol QuitVCDelegate: class {
    func isQuitDateSet()
}
