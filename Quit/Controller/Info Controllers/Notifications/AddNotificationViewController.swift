//
//  AddNotificationViewController.swift
//  Quit
//
//  Created by Alex Tudge on 24/05/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import MapKit
import CoreLocation
import UserNotifications

class AddNotificationViewController: QuitBaseViewController {
    
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var messageTextField: UITextField!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private var mapIndicatorViews: [UIView]!
    
    private var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegates()
    }
    
    @IBAction private func segmentedControllerDidChange(_ sender: UISegmentedControl) {
        mapView.isHidden = sender.selectedSegmentIndex == 0
        datePicker.isHidden = sender.selectedSegmentIndex == 1
        mapIndicatorViews.forEach {
            $0.isHidden = sender.selectedSegmentIndex == 0
        }
        if sender.selectedSegmentIndex == 1 {
            locationManager.requestLocation()
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    @IBAction private func didTapSaveButton(_ sender: Any) {
        guard titleTextField.text?.isEmpty == false,
            messageTextField.text?.isEmpty == false else {
                presentAlert(title: "🤷‍♀️", message: "You need to add a title and message!")
                return
        }
        if segmentedControl.selectedSegmentIndex == 0 {
            setTimeNotification()
        } else {
            setLocationNotification()
        }
    }
}

private extension AddNotificationViewController {
    func setupUI() {
        title = "Add notification"
        mapView.isHidden = true
    }
    
    func setupDelegates() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    func popController() {
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    func setTimeNotification() {
        let components = datePicker.calendar.dateComponents([.hour, .minute], from: datePicker.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let content = UNMutableNotificationContent()
        content.body = messageTextField.text ?? ""
        content.title = titleTextField.text ?? ""
        let locationNotification = UNNotificationRequest(identifier: "\(components)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(locationNotification) { _ in
            self.popController()
        }
    }
    
    func setLocationNotification() {
        let currentLocation = mapView.centerCoordinate
        let region = CLCircularRegion(center: currentLocation, radius: 20.0, identifier: "\(currentLocation)")
        region.notifyOnEntry = true
        region.notifyOnExit = false
        let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
        let content = UNMutableNotificationContent()
        content.body = messageTextField.text ?? ""
        content.title = titleTextField.text ?? ""
        let locationNotification = UNNotificationRequest(identifier: "customLocation\(currentLocation)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(locationNotification) { _ in
            self.popController()
        }
    }
}

extension AddNotificationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationManager.requestLocation()
        if status != .authorizedAlways {
            presentAlert(title: "😱", message: "You'll need to enable always location permissions in your phone's settings if you'd like receive location based notifications.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first?.coordinate {
            mapView.setCenter(location, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        return
    }
}
