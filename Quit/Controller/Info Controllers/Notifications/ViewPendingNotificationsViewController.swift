//
//  ViewPendingNotificationsViewController.swift
//  Quit
//
//  Created by Alex Tudge on 24/05/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import UIKit
import UserNotifications

class ViewPendingNotificationsViewContoller: QuitBaseViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private var notifications = [UNNotificationRequest]()
    private let center = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupNotifData()
        setupUI()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(!isEditing, animated: true)
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
}

private extension ViewPendingNotificationsViewContoller {
    func setupUI() {
        title = "Pending notifications"
        navigationItem.rightBarButtonItem = editButtonItem
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    func setupDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupNotifData() {
        center.getPendingNotificationRequests(completionHandler: { requests in
            requests.forEach {
                self.notifications.append($0)
            }
        })
        tableView.reloadData()
    }
    
    func cancelNotification(_ notification: UNNotificationRequest) {
        center.removePendingNotificationRequests(withIdentifiers: [notification.identifier])
    }
}

extension ViewPendingNotificationsViewContoller: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ViewNotificationCell", for: indexPath) as? ViewNotificationCell else {
            return UITableViewCell()
        }
        let notification = notifications[indexPath.row]
        cell.setupCell(title: notification.content.title, body: notification.content.body, date: (notification.trigger as? UNTimeIntervalNotificationTrigger)?.nextTriggerDate())
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let notification = notifications.remove(at: indexPath.row)
            cancelNotification(notification)
        }
        tableView.endEditing(true)
        tableView.reloadData()
    }
}
