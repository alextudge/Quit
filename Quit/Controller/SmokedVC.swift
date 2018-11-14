//
//  SmokedVC.swift
//  Quit
//
//  Created by Alex Tudge on 14/11/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class SmokedVC: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func didTapGotItButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
