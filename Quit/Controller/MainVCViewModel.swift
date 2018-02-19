//
//  MainVCViewModel
//  Quit
//
//  Created by Alex Tudge on 18/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import Foundation

class MainVCViewModel: NSObject {
    
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
    
    func mediumDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    func setUserDefaultsQuitDateToCurrent() {
        let quitData: [String: Any] = ["smokedDaily": self.quitData!.smokedDaily, "costOf20": self.quitData!.costOf20, "quitDate": Date()]
        self.userDefaults.set(quitData, forKey: "quitData")
    }
    
    func standardisedDate(date: Date) -> Date {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        let stringDate = formatter.string(from: date)
        return formatter.date(from: stringDate)!
    }
    
    func stringFromCurrencyFormatter(data: NSNumber) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: data)
    }
    
    func countdownLabel() -> String {
        return Date().offsetFrom(date: quitData!.quitDate)
    }
    
    func savingsProgressAngle(goalAmount: Double) -> Double {
        var angle = 0.0
        if self.quitDateIsInPast {
            angle = self.quitData!.savedSoFar / goalAmount * 360
        }
        if angle < 360 {
            return angle
        } else {
            return 360
        }
    }
}
