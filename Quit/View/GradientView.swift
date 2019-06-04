//
//  GradientView.swift
//  Quit
//
//  Created by Alex Tudge on 31/05/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    var startColor: UIColor = .white
    var endColor: UIColor = .white
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        (layer as? CAGradientLayer)?.colors = [startColor.cgColor, endColor.cgColor]
    }
}
