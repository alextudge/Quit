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
        backgroundColor = .quitSecondaryBackgroundColour
        layer.cornerRadius = 5
        layer.shadowColor = traitCollection.userInterfaceStyle == .dark ? UIColor.quitSecondaryBackgroundColour.cgColor : UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        clipsToBounds = false
    }
}
