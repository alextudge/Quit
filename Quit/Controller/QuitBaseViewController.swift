//
//  QuitBaseViewController.swift
//  Quit
//
//  Created by Alex Tudge on 07/04/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import UIKit

class QuitBaseViewController: UIViewController {
    
    var persistenceManager: PersistenceManager?
    var profile: Profile? {
        return persistenceManager?.getProfile()
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
    
    func presentQuitBaseViewController(_ viewController: QuitBaseViewController) {
        viewController.persistenceManager = persistenceManager
        viewController.modalPresentationStyle = .automatic
        present(viewController, animated: true, completion: nil)
    }
}

private extension QuitBaseViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.titleTextAttributes = attributes
        navigationController?.navigationBar.tintColor = .label
        if isModal {
            view.addSubview(swipeView())
        }
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
    
    func swipeView() -> UIView {
        let screenDivider = UIScreen.main.bounds.width / 3
        let swipeView = UIView(frame: CGRect(x: screenDivider, y: 17.5, width: screenDivider, height: 5))
        swipeView.layer.cornerRadius = 2.5
        swipeView.backgroundColor = UIColor(named: "blueColour")
        return swipeView
    }
}
