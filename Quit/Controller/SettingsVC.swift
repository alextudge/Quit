//
//  SettingsVC.swift
//  Quit
//
//  Created by Alex Tudge on 12/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class SettingsVC: QuitBaseViewController {
    
    @IBOutlet private weak var adFreeButton: RoundedButton!
    @IBOutlet private weak var purchaseStackView: UIStackView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Settings"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAdFreeOffers()
    }
    
    @IBAction private func deleteAllDataButtonPressed(_ sender: Any) {
        persistenceManager?.deleteAllData()
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapAdFreeButton(_ sender: Any) {
        purchaseAdFree()
    }
    
    @IBAction private func didTapRestorePurchases(_ sender: Any) {
        
    }
}

private extension SettingsVC {
    func getAdFreeOffers() {
        
    }
    
    func purchaseAdFree() {
        
    }
}
