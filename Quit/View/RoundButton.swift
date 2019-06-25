//
//  RoundButton.swift
//  Quit
//
//  Created by Alex Tudge on 01/06/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    override func layoutSubviews() {
        super .layoutSubviews()
        layer.cornerRadius = 5
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 1
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        clipsToBounds = false
        titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
    }
}
