//
//  AddNotificationViewController.swift
//  Quit
//
//  Created by Alex Tudge on 24/05/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import MapKit
import UserNotifications

class AddNotificationViewController: QuitBaseViewController {
    
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var messageTextField: UITextField!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction private func segmentedControllerDidChange(_ sender: UISegmentedControl) {
        mapView.isHidden = sender.selectedSegmentIndex == 0
        datePicker.isHidden = sender .selectedSegmentIndex == 1
    }
}

private extension AddNotificationViewController {
    func setupUI() {
        title = "Add notification"
        mapView.isHidden = true
    }
    
    func generateLocalNotif(time: Date, title: String, body: String) {
        
    }
}
