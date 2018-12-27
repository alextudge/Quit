//
//  SectionFiveReasonsToSmokeCell.swift
//  Quit
//
//  Created by Alex Tudge on 26/12/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

protocol SectionFiveReasonsToSmokeCellDelegate: class {
    func didTapEditButton(isReasonsToSmoke: Bool)
}

class SectionFiveReasonsToSmokeCell: UICollectionViewCell {

    @IBOutlet weak var roundedView: RoundedView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var isReasonsToSmoke = false
    private var gradientLayer: CAGradientLayer?
    
    weak var delegate: SectionFiveReasonsToSmokeCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        roundedView.frame = CGRect(x: CGFloat(5),
                                   y: CGFloat(5),
                                   width: UIScreen.main.bounds.width - 10,
                                   height: UIScreen.main.bounds.height / 2.3 - 10)
        roundedView.layer.cornerRadius = 10
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = roundedView.bounds
        gradientLayer?.cornerRadius = roundedView.layer.cornerRadius
    }
    
    func setup(data: AdditionalUserData?) {
        let color = Styles.Colours.orangeGradient
        gradientLayer = roundedView.gradient(colors: isReasonsToSmoke ? color : color.reversed())
        guard let data = data else {
            scrollView.addSubview(generateLabel(text: "Waiting for data"))
            return
        }
        let array = isReasonsToSmoke ? data.reasonsToSmoke : data.reasonsNotToSmoke
        array?.enumerated().forEach {
            scrollView.addSubview(generateLabel(text: $0.element, arrayPosition: $0.offset))
        }
    }
    
    @IBAction func didTapEditButton(_ sender: Any) {
        delegate?.didTapEditButton(isReasonsToSmoke: isReasonsToSmoke)
    }
}

private extension SectionFiveReasonsToSmokeCell {
    func generateLabel(text: String?, arrayPosition: Int = 0) -> UILabel {
        let label = UILabel(frame: CGRect(x: 20,
                                          y: arrayPosition * 30 + 10,
                                          width: Int(UIScreen.main.bounds.width) - 40,
                                          height: 30))
        label.text = text
        label.textColor = .white
        return label
    }
}
