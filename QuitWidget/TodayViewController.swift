//
//  TodayViewController.swift
//  QuitWidget
//
//  Created by Alex Tudge on 12/11/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var currentlySavedLabel: UILabel!
    @IBOutlet weak var registerCravingLabel: RoundedButton!
    
    private let userDefaults = UserDefaults.init(suiteName: "group.com.Alex.Quit")
    private let persistenceManager = PersistenceManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentlySavedLabel.text = "Calculating your savings..."
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        if let quitData = getQuitDataFromUserDefaults() {
            let savedSoFar = stringFromCurrencyFormatter(data: NSNumber(value: quitData.savedSoFar ?? 0))
            let savedSoFarString = savedSoFar ?? ""
            currentlySavedLabel.text = "You've saved " + savedSoFarString
            completionHandler(NCUpdateResult.newData)
        } else {
            completionHandler(NCUpdateResult.noData)
        }
    }
    
    private func getQuitDataFromUserDefaults() -> QuitData? {
        if let returnedData = userDefaults?.object(forKey: "quitData") as? [String: Any] {
            return QuitData(quitData: returnedData)
        }
        return nil
    }
    private func stringFromCurrencyFormatter(data: NSNumber) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: data)
    }
    
    @IBAction func didTapRecordCravingButton(_ sender: Any) {
        persistenceManager.addCraving(catagory: "", smoked: false)
    }
}
