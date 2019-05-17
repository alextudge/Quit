//
//  QuitBaseViewController.swift
//  Quit
//
//  Created by Alex Tudge on 07/04/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import UIKit

enum PresentationMode {
    case modal, push
}

class QuitBaseViewController: UIViewController {
    
    var largeTitlesEnabled = false
    var persistenceManager: PersistenceManager?
    var quitData: QuitData? {
        return persistenceManager?.quitData
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing()
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Got it", style: .cancel, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    func presentQuitBaseViewController(_ viewController: QuitBaseViewController, mode: PresentationMode = .push) {
        viewController.persistenceManager = persistenceManager
        if mode == .modal {
            present(viewController, animated: true, completion: nil)
        } else {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

private extension QuitBaseViewController {
    func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = largeTitlesEnabled
        navigationItem.largeTitleDisplayMode = .automatic
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        navigationController?.navigationBar.largeTitleTextAttributes = attributes
        navigationController?.navigationBar.titleTextAttributes = attributes
        navigationController?.navigationBar.tintColor = .darkGray
    }
    
    @objc private func endEditing() {
        view.endEditing(true)
    }
}
