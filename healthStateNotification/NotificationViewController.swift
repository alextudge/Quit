//
//  NotificationViewController.swift
//  healthStateNotification
//
//  Created by Alex Tudge on 15/11/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var waveAnimationView: UIView!
    
    func didReceive(_ notification: UNNotification) {
        
    }
}
