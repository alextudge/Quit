//
//  SectionOneCravingDataCell.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

protocol SectionOneCravingDataCellDelegate: class {
    func didPressChangeQuitDate()
    func didPressSegueToSettings()
    func reloadTableView()
    func presentAlert(_ alert: UIAlertController)
}

class SectionOneCravingDataCell: UICollectionViewCell {
    
    @IBOutlet weak var quitDateLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var addCravingButton: RoundedButton!
    
    var viewModel = SectionOneCravingDataCellViewModel()
    private var quitData: QuitData? {
        return viewModel.persistenceManager.getQuitDataFromUserDefaults()
    }
    
    weak var delegate: SectionOneCravingDataCellDelegate?
    
    func setup() {
        setupInitialUI()
        setupQuitTimer()
        displayQuitDate()
    }
    
    private func setupInitialUI() {
        let image = UIImage(named: "Plus")?.withRenderingMode(.alwaysTemplate)
        addCravingButton.setImage(image, for: .normal)
        addCravingButton.tintColor = .white
        quitDateLabel.isUserInteractionEnabled = true
        quitDateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressChangeQuitDateButton)))
        quitDateLabel.text = "No quit date set!"
    }
    
    private func displayQuitDate() {
        guard quitData?.quitDate != nil else {
            return
        }
        quitDateLabel.isHidden = false
        quitDateLabel.text = viewModel.stringQuitDate(quitData: quitData)
    }
    
    private func setupQuitTimer() {
        Timer.scheduledTimer(timeInterval: 1,
                             target: self,
                             selector: #selector(updateCountdownLabel),
                             userInfo: nil,
                             repeats: true)
    }
    
    @objc func updateCountdownLabel() {
        quitDateLabel.text = viewModel.countdownLabel(quitData: quitData)
    }
    
    @objc func didPressChangeQuitDateButton(_ sender: Any) {
        delegate?.didPressChangeQuitDate()
    }
    
    @IBAction func didPressSettingsButton(_ sender: Any) {
        delegate?.didPressSegueToSettings()
    }
    
    @IBAction func cravingButton(_ sender: Any) {
        let alertController = UIAlertController(title: viewModel.cravingButtonAlertTitle(),
                                                message: viewModel.cravingButtonAlertMessage(),
                                                preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            
            //Reset the quit date
            
            if self.viewModel.quitDateIsInPast(quitData: self.quitData) == true {
                self.viewModel.setUserDefaultsQuitDateToCurrent(quitData: self.quitData)
            }
            let textField = alertController.textFields![0] as UITextField
            self.viewModel.persistenceManager.addCraving(
                catagory: (textField.text != nil) ? textField.text!.capitalized : "",
                smoked: true)
            self.delegate?.reloadTableView()
        }
        alertController.addAction(yesAction)
        let noAction = UIAlertAction(title: "No", style: .default) { _ in
            let textField = alertController.textFields![0] as UITextField
            self.viewModel.persistenceManager.addCraving(
                catagory: (textField.text != nil) ? textField.text! : "",
                smoked: false)
            self.delegate?.reloadTableView()
            self.viewModel.appStoreReview(quitData: self.quitData)
        }
        alertController.addAction(noAction)
        alertController.addTextField { (textField) in
            textField.placeholder = "Mood/trigger"
        }
        delegate?.presentAlert(alertController)
    }
}
