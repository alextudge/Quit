//
//  QuitInfoDateCell.swift
//  Quit
//
//  Created by Alex Tudge on 08/11/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import UIKit

protocol QuitInfoDateCellDelegate: class {
    func didFinishEnteringData()
}

class QuitInfoDateCell: UICollectionViewCell, QuitBaseCellProtocol {
    
    @IBOutlet private weak var datePicker: UIDatePicker!
    
    var persistenceManager: PersistenceManager?
    
    weak var delegate: QuitInfoDateCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        populatePicker()
    }
    
    @IBAction private func didTapSaveButton(_ sender: Any) {
        persistValues()
        delegate?.didFinishEnteringData()
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
    }
}
