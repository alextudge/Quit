//
//  SettingsVC.swift
//  Quit
//
//  Created by Alex Tudge on 12/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

protocol SettingsVCDelegate: class {
    func segueToQuitDataViewController()
}

class SettingsVC: QuitBaseViewController {
        
    weak var delegate: SettingsVCDelegate?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Settings"
    }
    
    @IBAction private func deleteAllDataButtonPressed(_ sender: Any) {
        persistenceManager?.deleteAllData()
        dismiss(animated: true, completion: nil)
    }
}
