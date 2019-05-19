//
//  SectionTwoSavingsGoalCell.swift
//  Quit
//
//  Created by Alex Tudge on 05/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class SectionTwoSavingsGoalCell: UICollectionViewCell {
    
    var persistenceManager: PersistenceManager?
    private var label: UILabel?
    private var shapeLayer = CAShapeLayer()
    private var trackShapeLayer = CAShapeLayer()
    var savingGoal: SavingGoal? {
        didSet {
            guard let savingGoal = savingGoal else {
                return
            }
            animateProgressView()
            addSubview(savingsNameLabel(goal: savingGoal))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        savingsProgress()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label?.removeFromSuperview()
    }
}

private extension SectionTwoSavingsGoalCell {
    func savingsProgress() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.width * 0.5, y: frame.height), radius: frame.height * 0.5, startAngle: -CGFloat.pi / 3, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackShapeLayer.path = circularPath.cgPath
        trackShapeLayer.strokeColor = UIColor.lightGray.cgColor
        trackShapeLayer.lineWidth = 27.5
        trackShapeLayer.strokeEnd = 1
        trackShapeLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(trackShapeLayer)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = Styles.Colours.blueColor.cgColor
        shapeLayer.lineWidth = 30
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(shapeLayer)
    }
    
    func animateProgressView() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        let angle = savingsProgressAngle()
        basicAnimation.toValue = angle
        basicAnimation.duration = 2
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
        let pulseAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        pulseAnimation.duration = 3
        pulseAnimation.fromValue = 0.7
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .greatestFiniteMagnitude
        trackShapeLayer.add(pulseAnimation, forKey: "animateOpacity")
    }
    
    func savingsProgressAngle() -> Double {
        guard let quitData = persistenceManager?.quitData,
            let quitSavingsToDate = quitData.savedSoFar,
            let goalAmount = savingGoal?.goalAmount else {
                return 0
        }
        var angle = 0.0
        if self.quitDateIsInPast(quitData: persistenceManager?.quitData) {
            angle = quitSavingsToDate / goalAmount
        }
        if angle < 1 {
            return angle
        } else {
            return 1
        }
    }
    
    func savingsNameLabel(goal: SavingGoal) -> UILabel {
        label = UILabel(frame: CGRect(x: 20, y: 0, width: frame.width - 40, height: 100))
        guard let savingGoalName = goal.goalName else { return UILabel() }
        let string = NSAttributedString(string: savingGoalName, attributes: Styles.savingsInfoAttributes)
        label?.attributedText = string
        label?.lineBreakMode = .byWordWrapping
        label?.numberOfLines = 0
        label?.minimumScaleFactor = 0.5
        return label ?? UILabel()
    }
    
    func quitDateIsInPast(quitData: QuitData?) -> Bool {
        guard let quitDate = quitData?.quitDate else {
            return false
        }
        return quitDate < Date()
    }
}
