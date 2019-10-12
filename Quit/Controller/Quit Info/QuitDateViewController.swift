//
//  QuitDateViewController.swift
//  Quit
//
//  Created by Alex Tudge on 12/10/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import UIKit

class QuitDateViewController: QuitBaseViewController {

    @IBOutlet private weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populatePicker()
    }
    
    @IBAction private func didTapSaveButton(_ sender: Any) {
        persistValues()
        (parent as? QuitInfoPageViewController)?.dismiss(animated: true, completion: nil)
    }
}

private extension QuitDateViewController {
    func populatePicker() {
        if let currentDate = persistenceManager?.getProfile()?.quitDate {
            datePicker.date = currentDate
        }
    }
    
    func persistValues() {
        guard let persistenceManager = persistenceManager,
            let profile = persistenceManager.getProfile() else {
                return
        }
        profile.quitDate = datePicker.date
    }
}
