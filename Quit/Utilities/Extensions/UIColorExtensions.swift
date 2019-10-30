//
//  UIColorExtensions.swift
//  Quit
//
//  Created by Alex Tudge on 29/10/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import UIKit

extension UIColor {
    static var quitBackgroundColour: UIColor {
        return UIColor(named: "backgroundColour") ?? .systemBackground
    }
    static var quitSecondaryBackgroundColour: UIColor {
        return UIColor(named: "secondaryBackgroundColour") ?? .secondarySystemBackground
    }
    static var quitPrimaryColour: UIColor {
        return UIColor(named: "quitPrimaryColor") ?? .blue
    }
}
