//
//  QuitVCMV.swift
//  Quit
//
//  Created by Alex Tudge on 18/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import Foundation

class QuitVCVM: NSObject {
    
    var quitData: QuitData?
    let userDefaults = UserDefaults.standard
    
    override init() {
        super.init()
        userDefaults.addObserver(self, forKeyPath: "quitData", options: NSKeyValueObservingOptions.new, context: nil)
        if let returnedData = userDefaults.object(forKey: "quitData") as? [String: Any] {
            self.quitData = QuitData(quitData: returnedData)
        } else {
            self.quitData = nil
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let returnedData = userDefaults.object(forKey: "quitData") as? [String: Any] {
            quitData = QuitData(quitData: returnedData)
        }
    }
    
    var quitDateIsInPast: Bool {
        return quitData!.quitDate < Date()
    }
    
    func stringQuitDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: quitData!.quitDate)
    }
    
    func stringFromCurrencyFormatter(data: NSNumber) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: data)
    }
    
    func countdownLabel() -> String {
        return Date().offsetFrom(date: quitData!.quitDate)
    }
}
