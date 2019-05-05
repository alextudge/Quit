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

class AddCravingVC: QuitBaseViewController {
    
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var pickerView: UIPickerView!
    @IBOutlet private weak var bannerAdView: GADBannerView!
    
    let viewModel = AddCravingVCViewModel()
    weak var delegate: AddCravingVCDelegate?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.persistenceManager = persistenceManager
        setupDelegates()
        setupUI()
        setupAd()
    }
    
    private func setupDelegates() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    private func setupUI() {
        title = "Record a craving"
        textField.placeholder = "Add a new trigger here"
        textField.addDoneButtonToKeyboard(action: #selector(textField.resignFirstResponder))
        guard persistenceManager?.triggers?.count ?? 0 > 0 else {
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
        guard persistenceManager?.triggers?.count ?? 0 > 0 else {
            return nil
        }
        if let pickerTitle = pickerView(pickerView, titleForRow: pickerView.selectedRow(inComponent: 0), forComponent: 0) {
            return pickerTitle
        }
        return nil
    }
    
    @IBAction func didTapJustCravingButton(_ sender: Any) {
        persistenceManager?.addCraving(
            catagory: categoryForCraving(),
            smoked: false)
        viewModel.appStoreReview()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapISmokedButton(_ sender: Any) {
        if viewModel.quitDateIsInPast() == true {
            viewModel.setUserDefaultsQuitDateToCurrent()
        }
        persistenceManager?.addCraving(
            catagory: categoryForCraving(),
            smoked: true)
        navigationController?.popViewController(animated: true)
        delegate?.segueToSmokedVC()
    }
}

extension AddCravingVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return persistenceManager?.triggers?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let title = persistenceManager?.triggers?[row] else {
            return nil
        }
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.resignFirstResponder()
    }
}

extension AddCravingVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
