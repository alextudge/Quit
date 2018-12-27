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
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        
    }
}

private extension EditArrayVC {
    func textToArray(text: String) -> [String] {
        return text.components(separatedBy: [","])
    }
    
    func arrayToTextBlock(array: [String]) -> String {
        return array.joined(separator: ", ")
    }
}
