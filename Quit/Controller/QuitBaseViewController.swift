//
//  QuitBaseViewController.swift
//  Quit
//
//  Created by Alex Tudge on 07/04/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import UIKit

class QuitBaseViewController: UIViewController {
    
    var presentingView: UIView?
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
    
    func presentQuitBaseViewController(_ viewController: QuitBaseViewController) {
        viewController.persistenceManager = persistenceManager
        viewController.modalPresentationStyle = .automatic
        present(viewController, animated: true, completion: nil)
    }
}

private extension QuitBaseViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = largeTitlesEnabled
        navigationItem.largeTitleDisplayMode = .automatic
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.largeTitleTextAttributes = attributes
        navigationController?.navigationBar.titleTextAttributes = attributes
        navigationController?.navigationBar.tintColor = .secondarySystemBackground
        if isModal {
            addSwipeView()
        }
    }
    
    @objc private func endEditing() {
        view.endEditing(true)
    }
    
    func addSwipeView() {
        let screenDivider = UIScreen.main.bounds.width / 3
        let swipeView = UIView(frame: CGRect(x: screenDivider, y: 5, width: screenDivider, height: 5))
        swipeView.layer.cornerRadius = 2.5
        swipeView.backgroundColor = UIColor(named: "blueColour")
        view.addSubview(swipeView)
    }
}
