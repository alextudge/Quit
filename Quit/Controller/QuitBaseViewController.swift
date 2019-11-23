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
        super.touchesBegan(touches, with: event)
        endEditing()
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Got it", style: .cancel, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    func presentQuitBaseViewController(_ viewController: QuitBaseViewController, presentationStyle: UIModalPresentationStyle = .automatic) {
        viewController.persistenceManager = persistenceManager
        viewController.modalPresentationStyle = presentationStyle
        present(viewController, animated: true, completion: nil)
    }
}

private extension QuitBaseViewController {
    func setupUI() {
        view.backgroundColor = .quitBackgroundColour
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
        let closeButton = UIButton(type: .close)
        closeButton.frame = CGRect(x: UIScreen.main.bounds.width * 0.9, y: 10, width: 30, height: 30)
        closeButton.tintColor = .quitPrimaryColour
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        return closeButton
    }
    
    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
}
