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

    @IBOutlet weak var titleLabel: UILabel!
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        scrollView.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    func setup(data: AdditionalUserData?) {
        let color = Styles.Colours.orangeGradient
        gradientLayer = roundedView.gradient(colors: isReasonsToSmoke ? color : color.reversed())
        titleLabel.text = isReasonsToSmoke ? "Reasons to smoke" : "Reasons to quit"
        guard let data = data else {
            scrollView.addSubview(generateLabel(text: "Waiting for data"))
            return
        }
        let array = isReasonsToSmoke ? data.reasonsToSmoke : data.reasonsNotToSmoke
        array?.enumerated().forEach {
            scrollView.addSubview(generateLabel(text: $0.element, arrayPosition: $0.offset))
        }
        scrollView.contentSize = CGSize(width: Int(UIScreen.main.bounds.width - 40), height: (array?.count ?? 0) * 40)
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
        label.numberOfLines = 0
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        label.textColor = .white
        return label
    }
}
