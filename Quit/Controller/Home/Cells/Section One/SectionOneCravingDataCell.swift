//
//  SectionOneCravingDataCell.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import Lottie

protocol SectionOneCellsDelegate: class {
    func didPressChangeQuitDate()
    func didPressSegueToAchievements()
    func addCraving()
    func presentAlert(_ alert: UIAlertController)
}

class SectionOneCravingDataCell: UICollectionViewCell {
    
    @IBOutlet private weak var quitDateLabel: UILabel!
    @IBOutlet private weak var achievementsLottieView: AnimationView!
    @IBOutlet private weak var addCravingButton: RoundedButton!
    
    var viewModel = SectionOneCravingDataCellViewModel()
    
    weak var delegate: SectionOneCellsDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        achievementsLottieView.play()
    }
    
    func setup() {
        setupUI()
        setupQuitTimer()
        displayQuitDate()
    }
    
    @IBAction private func cravingButton(_ sender: Any) {
        delegate?.addCraving()
    }
    
    @IBAction private func achievementsButtonPressed(_ sender: Any) {
        delegate?.didPressSegueToAchievements()
    }
}

private extension SectionOneCravingDataCell {
    func setupUI() {
        let image = UIImage(named: "Plus")?.withRenderingMode(.alwaysTemplate)
        addCravingButton.setImage(image, for: .normal)
        addCravingButton.tintColor = .white
        quitDateLabel.isUserInteractionEnabled = true
        quitDateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressChangeQuitDateButton)))
        quitDateLabel.text = "No quit date set!"
    }
    
    @objc func didPressChangeQuitDateButton(_ sender: Any) {
        delegate?.didPressChangeQuitDate()
    }
    
    func displayQuitDate() {
        guard viewModel.quitData?.quitDate != nil else {
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
