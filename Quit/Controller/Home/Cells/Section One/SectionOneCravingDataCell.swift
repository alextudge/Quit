//
//  SectionOneCravingDataCell.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

protocol SectionOneCellsDelegate: class {
    func didPressChangeQuitDate()
    func presentAlert(_ alert: UIAlertController)
    func addCraving()
    func didPressSegueToAchievements()
}

class SectionOneCravingDataCell: UICollectionViewCell {
    
    @IBOutlet private weak var quitDateLabel: UILabel!
    
    var viewModel = SectionOneCravingDataCellViewModel()
    
    weak var delegate: SectionOneCellsDelegate?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layoutIfNeeded()
    }
    
    func setup() {
        setupUI()
        setupQuitTimer()
        displayQuitDate()
    }
    
    @IBAction private func didTapAchievementsButton(_ sender: Any) {
        delegate?.didPressSegueToAchievements()
    }
    
    @IBAction private  func didTapAddCravingButton(_ sender: Any) {
         delegate?.addCraving()
    }
}

private extension SectionOneCravingDataCell {
    func setupUI() {
        quitDateLabel.isUserInteractionEnabled = true
        quitDateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressChangeQuitDateButton)))
        quitDateLabel.text = "No quit date set!"
    }
    
    @objc func didPressChangeQuitDateButton(_ sender: Any) {
        delegate?.didPressChangeQuitDate()
    }
    
    func displayQuitDate() {
        guard viewModel.profile?.quitDate != nil else {
            return
        }
        quitDateLabel.isHidden = false
        quitDateLabel.text = viewModel.stringQuitDate()
    }
    
    func setupQuitTimer() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountdownLabel), userInfo: nil, repeats: true)
    }
    
    @objc func updateCountdownLabel() {
        quitDateLabel.text = viewModel.countdownLabel()
    }
}
