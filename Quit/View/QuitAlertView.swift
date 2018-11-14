//
//  QuitAlertView.swift
//  Quit
//
//  Created by Alex Tudge on 14/11/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

struct QuitAlertViewParameters {
    let title: String
    let message: String
    let secondButtonRequired: Bool
    let textFieldsRequired: Int?
}

protocol QuitAlertViewDelegate: class {
    var alertView: QuitAlertView? { get }
    func didPressButton(_ button: Int, textField1: String?, textField2: String?)
}

class QuitAlertView: RoundedView {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.sizeToFit()
        }
    }
    @IBOutlet weak var messageLabel: UILabel! {
        didSet {
            messageLabel.sizeToFit()
        }
    }
    @IBOutlet weak var textFieldOne: UILabel!
    @IBOutlet weak var textFieldTwo: UILabel!
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    
    weak var delegate: QuitAlertViewDelegate?
    
    private let screensize = UIScreen.main.bounds
    private var overlay: UIView!
    private(set) var parameters: QuitAlertViewParameters?
    
    static func initFromNibFile(_ parameters: QuitAlertViewParameters, delegate: QuitAlertViewDelegate) -> QuitAlertView {
        let dateAlertView: QuitAlertView = UIView.fromNib()
        dateAlertView.delegate = delegate
        dateAlertView.setup(with: parameters)
        return dateAlertView
    }
    
    private func setup(with parameters: QuitAlertViewParameters) {
        self.parameters = parameters
        let topcontroller = UIApplication.topViewController()?.view
        overlay = UIView(frame: topcontroller?.superview?.bounds ?? screensize)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        overlay.addGestureRecognizer(tap)
        overlay.backgroundColor = .clear
        if parameters.secondButtonRequired {
            buttonTwo.isHidden = false
            buttonTwo.backgroundColor = .lightGray
        }
        if parameters.textFieldsRequired == 1 {
            textFieldOne.isHidden = false
        } else if parameters.textFieldsRequired == 2 {
            textFieldOne.isHidden = false
            textFieldTwo.isHidden = false
        }
        buttonOne.backgroundColor = .lightGray
        titleLabel.text = parameters.title
        messageLabel.text = parameters.message
        backgroundColor = .white
        layer.cornerRadius = 10
        layoutSubviews()
    }
    
    func showAlert() {
        let alertFrame = CGRect(x: 50 - screensize.width, y: ((screensize.height * 0.6) / 3) - screensize.height, width: screensize.width - 100, height: screensize.height * 0.4)
        frame = alertFrame
        let topViewController = UIApplication.topViewController()
        topViewController?.view.addSubview(overlay)
        topViewController?.view.addSubview(self)
        fadeOverlayIn()
        animateAlertIn()
    }
    
    private func animateAlertIn() {
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: ({
            self.frame.origin.y += self.screensize.height
            self.frame.origin.x += self.screensize.width
        }), completion: nil)
    }
    
    private func fadeOverlayIn() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
            self.overlay.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6)
        }, completion: nil)
    }
    
    func changeMessageText(_ text: String?) {
        let delay = text == "" ? 1.0 : 0.0
        UIView.animate(withDuration: 1, delay: delay, options:[.transitionCrossDissolve], animations: {
            self.messageLabel.text = text
        }) { _ in
            self.layoutSubviews()
        }
    }
    
    func clearTextFieldText() {
        textFieldOne.text = ""
        textFieldTwo.text = ""
    }
    
    func removeAlert() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
            self.overlay.backgroundColor = UIColor.darkGray.withAlphaComponent(0)
        }) { _ in
            self.overlay.removeFromSuperview()
        }
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.frame.origin.y -= self.screensize.height
            self.frame.origin.x -= self.screensize.width
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
    @IBAction private func didPressButtonOne(_ sender: Any) {
        delegate?.didPressButton(1, textField1: textFieldOne.text, textField2: textFieldTwo.text)
    }
    
    @IBAction private func didPressButtonTwo(_ sender: Any) {
        delegate?.didPressButton(2, textField1: textFieldOne.text, textField2: textFieldTwo.text)
    }
}
