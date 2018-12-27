//
//  EditArrayVC.swift
//  Quit
//
//  Created by Alex Tudge on 27/12/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class EditArrayVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editArrayTextView: UITextView!
    
    var persistenceManager: PersistenceManager?
    var isReasonsToSmoke = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editArrayTextView.delegate = self
        setupUI()
    }
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

private extension EditArrayVC {
    func setupUI() {
        editArrayTextView.layer.cornerRadius = 10
        editArrayTextView.layer.borderWidth = 2
        editArrayTextView.layer.borderColor = UIColor.white.cgColor
        if isReasonsToSmoke {
            editArrayTextView.text = arrayToTextBlock(array: persistenceManager?.additionalUserData?.reasonsToSmoke ?? [])
        } else {
            editArrayTextView.text = arrayToTextBlock(array: persistenceManager?.additionalUserData?.reasonsNotToSmoke ?? [])
        }
        editArrayTextView.becomeFirstResponder()
    }
    
    func textToArray(text: String) -> [String] {
        return text.components(separatedBy: [","])
    }
    
    func arrayToTextBlock(array: [String]) -> String {
        return array.joined(separator: ", ")
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
