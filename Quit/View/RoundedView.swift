//
//  RoundedView.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class RoundedView: UIView {
    override func layoutSubviews() {
        super .layoutSubviews()
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 1
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        clipsToBounds = false
    }
}
