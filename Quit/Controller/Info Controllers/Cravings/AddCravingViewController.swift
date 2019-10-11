//
//  AddCravingVC.swift
//  Quit
//
//  Created by Alex Tudge on 15/11/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import GoogleMobileAds
import Intents
import IntentsUI

protocol AddCravingViewControllerDelegate: class {
    func segueToSmokedViewController()
}

class AddCravingViewController: QuitBaseViewController {
    
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var pickerView: UIPickerView!
    @IBOutlet private weak var bannerAdView: GADBannerView!
    
    private var viewModel: AddCravingViewModel!
    
    weak var delegate: AddCravingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AddCravingViewModel(persistenceManager: persistenceManager)
        setupDelegates()
        setupUI()
        setupAd()
    }
    
    @IBAction private func didTapJustCravingButton(_ sender: Any) {
        persistenceManager?.addCraving(catagory: categoryForCraving(), smoked: false)
        viewModel.appStoreReview()
        donateInteraction()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapISmokedButton(_ sender: Any) {
        if viewModel.quitDateIsInPast() == true {
            persistenceManager?.getProfile()?.quitDate = Date()
            persistenceManager?.saveContext()
        }
        persistenceManager?.addCraving(catagory: categoryForCraving(), smoked: true)
        dismiss(animated: true, completion: nil)
        delegate?.segueToSmokedViewController()
    }
}

private extension AddCravingViewController {
    func setupUI() {
        title = "Record a craving"
        addSiriButton()
        textField.placeholder = "Type a new trigger here"
        textField.addDoneButtonToKeyboard(action: #selector(textField.resignFirstResponder))
        if persistenceManager?.getTriggers().isEmpty == true {
            pickerView.isHidden = true
        }
    }
    
    func setupDelegates() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func addSiriButton() {
        let button = INUIAddVoiceShortcutButton(style: .automaticOutline)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        view.topAnchor.constraint(equalTo: button.topAnchor, constant: -40).isActive = true
        view.rightAnchor.constraint(equalTo: button.rightAnchor, constant: 10).isActive = true
        button.addTarget(self, action: #selector(addToSiri(_:)), for: .touchUpInside)
    }
    
    @objc func addToSiri(_ sender: Any) {
        if let shortcut = INShortcut(intent: AddCravingIntent()) {
            let viewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
            viewController.modalPresentationStyle = .formSheet
            viewController.delegate = self
            present(viewController, animated: true, completion: nil)
        }
    }
    
    func donateInteraction() {
        let intent = AddCravingIntent()
        intent.suggestedInvocationPhrase = "Add a craving"
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate { _ in }
    }
    
    func setupAd() {
        guard persistenceManager?.isAdFree() == false else {
            bannerAdView.isHidden = true
            return
        }
        bannerAdView.adUnitID = Constants.AppConfig.adBannerId
        bannerAdView.rootViewController = self
        bannerAdView.load(GADRequest())
    }
    
    func categoryForCraving() -> String {
        if let text = textField.text,
            text != "" {
            return text
        } else if let pickerTitle = getPickerTitle() {
            return pickerTitle
        } else {
            return ""
        }
    }
    
    func getPickerTitle() -> String? {
        guard persistenceManager?.getTriggers().count ?? 0 > 0 else {
            return nil
        }
        if let pickerTitle = pickerView(pickerView, titleForRow: pickerView.selectedRow(inComponent: 0), forComponent: 0) {
            return pickerTitle
        }
        return nil
    }
}

extension AddCravingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return persistenceManager?.getTriggers().count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let title = persistenceManager?.getTriggers()[row] else {
            return nil
        }
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.resignFirstResponder()
    }
}

extension AddCravingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

extension AddCravingViewController: INUIAddVoiceShortcutViewControllerDelegate {
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
