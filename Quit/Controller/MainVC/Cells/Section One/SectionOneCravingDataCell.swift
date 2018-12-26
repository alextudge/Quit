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
    func didPressSegueToAchievements()
    func addCraving()
    func segueToSmokedVC()
    func presentAlert(_ alert: UIAlertController)
}

class SectionOneCravingDataCell: UICollectionViewCell {
    
    @IBOutlet weak var roundedView: RoundedView!
    @IBOutlet weak var quitDateLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var addCravingButton: RoundedButton!
    
    var viewModel = SectionOneCravingDataCellViewModel()
    private var gradientLayer: CAGradientLayer?
    private var quitData: QuitData? {
        return viewModel.persistenceManager.quitData
    }
    
    weak var delegate: SectionOneCravingDataCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gradientLayer = roundedView.gradient(colors: Styles.Colours.blueGradient)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = roundedView.bounds
        gradientLayer?.cornerRadius = roundedView.layer.cornerRadius
    }
    
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
        delegate?.addCraving()
    }
    
    @IBAction func achievementsButtonPressed(_ sender: Any) {
        delegate?.didPressSegueToAchievements()
    }
}
