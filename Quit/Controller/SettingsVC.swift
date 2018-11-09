//
//  SettingsVC.swift
//  Quit
//
//  Created by Alex Tudge on 12/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    @IBOutlet private weak var deleteAllDataButton: UIButton!
    
    weak var delegate: QuitDateSetVCDelegate?
    var persistenceManager: PersistenceManagerProtocol?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction private func goBackButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func deleteAllDataButtonPressed(_ sender: Any) {
        persistenceManager?.deleteAllData()
        delegate?.reloadTableView()
        dismiss(animated: true, completion: nil)
    }
}
