//
//  QuitInfoDateCell.swift
//  Quit
//
//  Created by Alex Tudge on 08/11/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import UIKit

protocol QuitInfoDateCellDelegate: class {
    func didFinishEnteringData(enablenotifications: Bool)
}

class QuitInfoDateCell: UICollectionViewCell, QuitBaseCellProtocol {
    
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var notificationsTitleLabel: QuitLabel!
    @IBOutlet private weak var enableNotificationsSwitch: UISwitch!
    
    var persistenceManager: PersistenceManager?
    
    weak var delegate: QuitInfoDateCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        notificationsTitleLabel.sizeToFit()
        enableNotificationsSwitch.onTintColor = .quitPrimaryColour
    }
    
    func setup(persistenceManager: PersistenceManager?) {
        self.persistenceManager = persistenceManager
        populatePicker()
    }
    
    @IBAction private func didTapSaveButton(_ sender: Any) {
        persistValues()
        delegate?.didFinishEnteringData(enablenotifications: enableNotificationsSwitch.isOn)
    }
}

private extension QuitInfoDateCell {
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
        persistenceManager.saveContext()
    }
}
