//
//  AnimationViewController.swift
//  Quit
//
//  Created by Alex Tudge on 31/05/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import UIKit

class AnimationViewController: QuitBaseViewController {
    
    @IBOutlet private weak var messageLabel: UILabel!
    
    private let sky = GradientView()
    private let stars = ParticleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.bringSubviewToFront(messageLabel)
        startMessageCycle()
    }
}

private extension AnimationViewController {
    func setupAnimation() {
        sky.startColor = .black
        sky.endColor = .black
        sky.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sky)
        stars.particleImage = UIImage(named: "particle")
        stars.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stars)
        NSLayoutConstraint.activate([
            stars.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stars.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stars.topAnchor.constraint(equalTo: view.topAnchor),
            stars.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sky.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sky.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sky.topAnchor.constraint(equalTo: view.topAnchor),
            sky.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    func startMessageCycle() {
        animateLabel("Life on earth is immensely improbable.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.animateLabel("Don't shorten your experience of it.")
            self.sky.startColor = .white
            self.sky.endColor = .white
            self.sky.layoutSubviews()
            self.stars.starColour = .darkGray
            self.stars.emissionRange = 0.2
            self.messageLabel.textColor = .black
            self.stars.layoutSubviews()
        }
    }
    
    func animateLabel(_ message: String) {
        UIView.transition(with: messageLabel, duration: 1, options: .transitionCrossDissolve, animations: { [weak self] in
            self?.messageLabel.text = message
        }, completion: nil)
    }
}
