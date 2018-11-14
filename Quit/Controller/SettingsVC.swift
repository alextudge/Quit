//
//  SettingsVC.swift
//  Quit
//
//  Created by Alex Tudge on 12/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

protocol SettingsVCDelegate: class {
    func reloadTableView(_ withSections: [Int]?)
    func segueToQuitDataVC()
}

class SettingsVC: UIViewController {
    
    @IBOutlet private weak var deleteAllDataButton: UIButton!
    
    weak var delegate: SettingsVCDelegate?
    var persistenceManager: PersistenceManagerProtocol?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.97)
    }
    
    @IBAction private func goBackButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func deleteAllDataButtonPressed(_ sender: Any) {
        persistenceManager?.deleteAllData()
        delegate?.reloadTableView(nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapChangeQuitDate(_ sender: Any) {
        dismiss(animated: true) {
            self.delegate?.segueToQuitDataVC()
        }
    }
}
