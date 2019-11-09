//
//  SectionFiveNotificationsCell.swift
//  Quit
//
//  Created by Alex Tudge on 21/05/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import UIKit

protocol SectionFiveNotificationsCellDelegate: class {
    func showViewController(_ viewController: ViewControllerFactory)
}

class SectionFiveNotificationsCell: UICollectionViewCell {
    
    weak var delegate: SectionFiveNotificationsCellDelegate?
    
    @IBAction private func didTapViewAllNotifsButton(_ sender: Any) {
        delegate?.showViewController(.ViewPendingNotificationsViewContoller)
    }
    
    @IBAction private func didTapSetCustomNotifButton(_ sender: Any) {
        delegate?.showViewController(.AddNotificationViewController)
    }
}
