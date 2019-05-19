//
//  EditArrayVC.swift
//  Quit
//
//  Created by Alex Tudge on 27/12/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class EditArrayVC: QuitBaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editArrayTextView: UITextView!
    
    var isReasonsToSmoke = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editArrayTextView.delegate = self
        setupUI()
    }
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        saveNewEntries(entries: textToArray(text: editArrayTextView.text))
        dismiss(animated: true, completion: nil)
    }
}

private extension EditArrayVC {
    func setupUI() {
        editArrayTextView.layer.cornerRadius = 10
        editArrayTextView.layer.borderWidth = 2
        editArrayTextView.layer.borderColor = UIColor.lightGray.cgColor
        editArrayTextView.textColor = .darkGray
        if isReasonsToSmoke {
            editArrayTextView.text = arrayToTextBlock(array: persistenceManager?.additionalUserData?.reasonsToSmoke ?? [])
        } else {
            editArrayTextView.text = arrayToTextBlock(array: persistenceManager?.additionalUserData?.reasonsNotToSmoke ?? [])
        }
        editArrayTextView.becomeFirstResponder()
        titleLabel.text = appropriateTitleText()
    }
    
    func appropriateTitleText() -> String {
        if isReasonsToSmoke {
            return "List the reasons you smoke here. Most people struggle to think of many..."
        } else {
            return "List the reasons you want to quit here"
        }
    }
    
    func textToArray(text: String) -> [String] {
        return text.components(separatedBy: [","]).map {
            $0.trimmingCharacters(in: .whitespaces).capitalized
        }
    }
    
    func arrayToTextBlock(array: [String]) -> String {
        return array.joined(separator: ", ")
    }
    
    func saveNewEntries(entries: [String]) {
        let reasonsToSmoke: [String]? = isReasonsToSmoke ? entries : (persistenceManager?.additionalUserData?.reasonsToSmoke ?? [])
        let reasonsNotToSmoke: [String]? = isReasonsToSmoke ? (persistenceManager?.additionalUserData?.reasonsNotToSmoke ?? []) : entries
        let newData = [Constants.AdditionalUserDataConstants.reasonsNotToSmoke: reasonsNotToSmoke,
                       Constants.AdditionalUserDataConstants.reasonsToSmoke: reasonsToSmoke]
        persistenceManager?.setAdditionalParametersInUserDefaults(object: newData as [String: Any])
    }
}

extension EditArrayVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
