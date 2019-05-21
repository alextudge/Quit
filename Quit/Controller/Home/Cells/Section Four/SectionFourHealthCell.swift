//
//  SectionFourHealthCell.swift
//  Quit
//
//  Created by Alex Tudge on 15/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import Lottie

class SectionFourHealthCell: UICollectionViewCell {

    @IBOutlet private weak var healthStateLabel: UILabel!
    @IBOutlet private weak var progressLottieView: AnimationView!
    
    private var shapeLayer = CAShapeLayer()
    private var trackShapeLayer = CAShapeLayer()
    
    var persistenceManager: PersistenceManager?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSavingProgress()
    }
    
    func setupCell(data: Constants.HealthStats) {
        guard let quitData = persistenceManager?.quitData,
            let minuteSmokeFree = quitData.minutesSmokeFree else {
            return
        }
        let time = data.secondsForHealthState() / 60
        let progress = Float(minuteSmokeFree / time)
        shapeLayer.isHidden = progress >= 1
        trackShapeLayer.isHidden = progress >= 1
        progressLottieView.animation = nil
        if progress >= 1 {
            progressLottieView.animation = Animation.named("progressComplete")
            progressLottieView.play()
        } else {
            animateProgressView(progress: progress)
        }
        healthStateLabel.text = data.rawValue
        healthStateLabel.textColor = .lightGray
        layoutIfNeeded()
        reshapeProgressLayers()
    }
}

private extension SectionFourHealthCell {
    func setupSavingProgress() {
        trackShapeLayer.strokeColor = UIColor.lightGray.cgColor
        trackShapeLayer.lineWidth = 10
        trackShapeLayer.strokeEnd = 1
        trackShapeLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(trackShapeLayer)
        shapeLayer.strokeColor = Styles.Colours.blueColor.cgColor
        shapeLayer.lineWidth = 15
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(shapeLayer)
    }
    
    func animateProgressView(progress: Float) {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        let angle = progress
        basicAnimation.toValue = angle
        basicAnimation.duration = 2
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
    
    func reshapeProgressLayers() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: progressLottieView.frame.midX, y: progressLottieView.frame.midY), radius: (progressLottieView.frame.height / 2.0) - 7.5, startAngle: -CGFloat.pi / 3, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackShapeLayer.path = circularPath.cgPath
        shapeLayer.path = circularPath.cgPath
    }
}
