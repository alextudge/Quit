//
//  QuitInfoVC.swift
//  Quit
//
//  Created by Alex Tudge on 04/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit
import UserNotifications

class QuitInfoVC: UIViewController, UITextFieldDelegate {
    
    weak var delegate: QuitVCDelegate?
    let defaults = UserDefaults.standard
    var quitData: QuitData? = nil

    @IBOutlet weak var cigarettesSmokedDaily: UITextField!
    @IBOutlet weak var costOf20: UITextField!
    @IBOutlet weak var quitDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        
        cigarettesSmokedDaily.delegate = self
        costOf20.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if quitData != nil {
            self.costOf20.text = String(quitData!.costOf20)
            self.cigarettesSmokedDaily.text = String(quitData!.smokedDaily)
            self.quitDatePicker.date = (quitData?.quitDate)!
        }
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
    
    func showDataMissingAlert() {
        
        let alert = UIAlertController(title: "Add all data!", message: "", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if costOf20.text != "" && cigarettesSmokedDaily.text != "" {
            guard let cost = Double(costOf20.text!), let amount = Double(cigarettesSmokedDaily.text!) else {
                showDataMissingAlert()
                return
            }
            let quitData: [String: Any] = ["smokedDaily": amount, "costOf20": cost, "quitDate": quitDatePicker.date]
            self.cancelAppleLocalNotifs()
            self.setLocalNotif()
            defaults.set(quitData, forKey: "quitData")
            delegate?.isQuitDateSet()
            dismiss(animated: true, completion: nil)
        } else {
            showDataMissingAlert()
            return
        }
    }
    
    func setLocalNotif() {
        
        for x in Constants.healthStats {
            generateLocalNotif(title: x.key, body: "Process complete!", minutes: Int(x.value))
        }
    }
    
    func generateLocalNotif(title: String, body: String, minutes: Int) {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = UNNotificationSound.default()
            let date = Date(timeInterval: TimeInterval(minutes * 60), since: quitDatePicker.date)
            let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
    }
    
    func cancelAppleLocalNotifs() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
}

protocol QuitVCDelegate: class {
    func isQuitDateSet()
}
