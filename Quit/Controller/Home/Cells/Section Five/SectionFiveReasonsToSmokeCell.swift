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

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var roundedView: RoundedView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var stackView: UIStackView!
    
    var isReasonsToSmoke = false
    
    weak var delegate: SectionFiveReasonsToSmokeCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setup(data: Profile?) {
        stackView.subviews.forEach {
            $0.removeFromSuperview()
        }
        titleLabel.text = isReasonsToSmoke ? "Reasons to smoke" : "Reasons to quit"
        guard let data = data else {
            stackView.addArrangedSubview(generateLabel(text: "Waiting for data"))
            return
        }
        let array = (isReasonsToSmoke ? data.reasonsToSmoke : data.reasonsToQuit) as? [String]
        array?.enumerated().forEach {
            stackView.addArrangedSubview(generateLabel(text: $0.element))
        }
        stackView.spacing = 5
        scrollView.contentSize = stackView.frame.size
    }
    
    @IBAction func didTapEditButton(_ sender: Any) {
        delegate?.didTapEditButton(isReasonsToSmoke: isReasonsToSmoke)
    }
}

private extension SectionFiveReasonsToSmokeCell {
    func setupUI() {
        scrollView.layer.cornerRadius = 5
        scrollView.layer.borderWidth = 1
        scrollView.layer.borderColor = UIColor.label.withAlphaComponent(0.5).cgColor

    }
    
    func generateLabel(text: String?) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 20, width: Int(UIScreen.main.bounds.width) - 40, height: 30))
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        label.textColor = .darkGray
        return label
    }
}
