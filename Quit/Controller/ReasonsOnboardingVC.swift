//
//  ReasonsOnboardingVC.swift
//  Quit
//
//  Created by Alex Tudge on 27/12/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

protocol ReasonsOnboardingVCDelegate: class {
    func didTapLetsGoButton()
}

class ReasonsOnboardingVC: UIViewController {

    weak var delegate: ReasonsOnboardingVCDelegate?
    
    @IBAction func notNowButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func letsGoButtonPressed(_ sender: Any) {
        dismiss(animated: true) {
            self.delegate?.didTapLetsGoButton()
        }
    }
}
