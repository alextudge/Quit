//
//  QuitInfoPageViewController.swift
//  Quit
//
//  Created by Alex Tudge on 12/10/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import UIKit

class QuitInfoViewController: QuitBaseViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.contentOffset = .zero
    }
}

private extension QuitInfoViewController {
    func setupDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func generateLocalNotif(quitDate: Date?) {
        guard let quitDate = quitDate else {
            return
        }
        cancelAppleLocalNotifs()
        HealthStats.allCases.forEach {
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings { settings in
                guard settings.authorizationStatus == .authorized else {
                    return
                }
            }
            let minutes = Int($0.secondsForHealthState() / 60)
            let content = UNMutableNotificationContent()
            content.title = "New health improvement"
            content.subtitle = "\(minutes) minutes smoke free!"
            content.body = $0.rawValue
            content.sound = .default
            let date = Date(timeInterval: TimeInterval(minutes * 60), since: quitDate)
            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            let request = UNNotificationRequest(identifier: $0.rawValue, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func cancelAppleLocalNotifs() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: HealthStats.allCases.compactMap { $0.rawValue })
    }
}

extension QuitInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuitInfoCostCell", for: indexPath) as? QuitInfoCostCell {
                cell.delegate = self
                cell.setup(persistenceManager: persistenceManager)
                return cell
            }
        case 1:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuitInfoDateCell", for: indexPath) as? QuitInfoDateCell {
                cell.delegate = self
                cell.setup(persistenceManager: persistenceManager)
                return cell
            }
        default:
            break
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}

extension QuitInfoViewController: QuitInfoCostCellDelegate {
    func goToNextPage() {
        collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension QuitInfoViewController: QuitInfoDateCellDelegate {
    func didFinishEnteringData(enablenotifications: Bool) {
        NotificationCenter.default.post(Notification(name: Constants.InternalNotifs.quitDateChanged))
        if enablenotifications {
            generateLocalNotif(quitDate: persistenceManager?.getProfile()?.quitDate)
        } else {
            cancelAppleLocalNotifs()
        }
        dismiss(animated: true, completion: nil)
    }
}
