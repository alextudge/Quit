//
//  SectionFiveReasonsNotToSmokeCell.swift
//  Quit
//
//  Created by Alex Tudge on 26/12/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class SectionFiveReasonsNotToSmokeCell: UICollectionViewCell {

    @IBOutlet weak var roundedView: RoundedView!
    
    private var gradientLayer: CAGradientLayer?

    override func awakeFromNib() {
        super.awakeFromNib()
        gradientLayer = roundedView.gradient(colors: Styles.Colours.greenGradient.reversed())
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = roundedView.bounds
        gradientLayer?.cornerRadius = roundedView.layer.cornerRadius
    }
}
