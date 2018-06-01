//
//  SettingsVC.swift
//  Quit
//
//  Created by Alex Tudge on 12/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    @IBOutlet weak var deleteAllDataButton: UIButton!
    
    weak var delegate: QuitVCDelegate?
    var persistenceManager: PersistenceManagerProtocol?
    
    @IBAction func goBackButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteAllDataButtonPressed(_ sender: Any) {
        
        persistenceManager?.deleteAllData()
        delegate?.isQuitDateSet()
        self.dismiss(animated: true, completion: nil)
    }
}

protocol SettingsVCDelegate: class {
    func isQuitDateSet()
}
