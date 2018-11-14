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
    var label: UILabel?
    var shapeLayer = CAShapeLayer()
    var trackShapeLayer = CAShapeLayer()
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
        
    private func savingsProgress() {
        let circularPath = UIBezierPath(arcCenter: center,
                                        radius: frame.height * 0.4,
                                        startAngle: -CGFloat.pi / 3,
                                        endAngle: 2 * CGFloat.pi,
                                        clockwise: true)
        trackShapeLayer.path = circularPath.cgPath
        trackShapeLayer.strokeColor = UIColor.lightGray.cgColor
        trackShapeLayer.lineWidth = 27.5
        trackShapeLayer.strokeEnd = 1
        trackShapeLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(trackShapeLayer)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = Constants.Colours.greenColour.cgColor
        shapeLayer.lineWidth = 30
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(shapeLayer)
    }
    
    private func animateProgressView() {
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
    
    private func savingsProgressAngle() -> Double {
        guard let quitData = persistenceManager?.getQuitDataFromUserDefaults(),
            let quitSavingsToDate = quitData.savedSoFar,
            let goalAmount = savingGoal?.goalAmount else {
            return 0
        }
        var angle = 0.0
        if self.quitDateIsInPast(quitData: persistenceManager?.getQuitDataFromUserDefaults()) {
            angle = quitSavingsToDate / goalAmount
        }
        if angle < 1 {
            return angle
        } else {
            return 1
        }
    }
    
    private func savingsNameLabel(goal: SavingGoal) -> UILabel {
        label = UILabel(frame: CGRect(x: 0,
                                      y: 0,
                                      width: frame.width,
                                      height: 100))
        guard let savingGoalName = goal.goalName else { return UILabel() }
        let string = NSAttributedString(string: savingGoalName, attributes: Constants.savingsInfoAttributes)
        label?.attributedText = string
        label?.lineBreakMode = .byWordWrapping
        label?.numberOfLines = 0
        label?.minimumScaleFactor = 0.5
        return label ?? UILabel()
    }
    
    func quitDateIsInPast(quitData: QuitData?) -> Bool {
        guard let quitDate = quitData?.quitDate else { return false }
        return quitDate < Date()
    }
}
