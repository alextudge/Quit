//
//  NotificationViewController.swift
//  HealthAchievementNotification
//
//  Created by Alex Tudge on 27/06/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import Lottie
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var lottieView: AnimationView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lottieView.play()
    }
    
    func didReceive(_ notification: UNNotification) {
        titleLabel.text = notification.request.content.title
        label?.text = notification.request.content.body
    }
}
