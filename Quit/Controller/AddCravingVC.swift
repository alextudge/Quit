//
//  AddCravingVC.swift
//  Quit
//
//  Created by Alex Tudge on 15/11/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit
import GoogleMobileAds

protocol AddCravingVCDelegate: class {
    func segueToSmokedVC()
}

class AddCravingVC: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var bannerAdView: GADBannerView!
    
    let viewModel = AddCravingVCViewModel()
    weak var delegate: AddCravingVCDelegate?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupUI()
        setupAd()
    }
    
    private func setupDelegates() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    private func setupUI() {
        textField.placeholder = "Add a new trigger here"
        guard viewModel.persistenceManager?.triggers?.count ?? 0 > 0 else {
            pickerView.isHidden = true
            return
        }
    }
    
    private func setupAd() {
        bannerAdView.adUnitID = Constants.AppConfig.adBannerId
        bannerAdView.rootViewController = self
        bannerAdView.load(GADRequest())
    }
    
    private func categoryForCraving() -> String {
        if let text = textField.text,
            text != "" {
            return text
        } else if let pickerTitle = getPickerTitle() {
            return pickerTitle
        } else {
            return ""
        }
    }
    
    private func getPickerTitle() -> String? {
        guard viewModel.persistenceManager?.triggers?.count ?? 0 > 0 else {
            return nil
        }
        if let pickerTitle = pickerView(pickerView, attributedTitleForRow: pickerView.selectedRow(inComponent: 0), forComponent: 0)?.string {
            return pickerTitle
        }
        return nil
    }
    
    @IBAction func didTapJustCravingButton(_ sender: Any) {
        viewModel.persistenceManager?.addCraving(
            catagory: categoryForCraving(),
            smoked: false)
        viewModel.appStoreReview()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapISmokedButton(_ sender: Any) {
        if viewModel.quitDateIsInPast() == true {
            viewModel.setUserDefaultsQuitDateToCurrent()
        }
        viewModel.persistenceManager?.addCraving(
            catagory: categoryForCraving(),
            smoked: true)
        dismiss(animated: true) {
            self.delegate?.segueToSmokedVC()
        }
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddCravingVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.persistenceManager?.triggers?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        guard let title = viewModel.persistenceManager?.triggers?[row] else {
            return nil
        }
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        return NSAttributedString(string: title, attributes: attributes)
    }
}

extension AddCravingVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
