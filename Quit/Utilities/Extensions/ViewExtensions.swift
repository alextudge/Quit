//
//  ViewExtensions.swift
//  Quit
//
//  Created by Alex Tudge on 26/12/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

extension UIView {
    func gradient(colors: [CGColor]) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius
        gradientLayer.colors = colors
        layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }    
}
