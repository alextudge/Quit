//
//  WaveAnimationView.swift
//  Quit
//
//  Created by Alex Tudge on 15/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class WaveAnimationView: UIView {
    
    private var originX = 0.0
    private let cycle = 1.0
    private var term = 60.0
    private var phasePosition = 0.0
    private var amplitude = 29.0
    private var position = 40.0
    private let animationMoveSpan = 5.0
    private let animationUnitTime = 0.25
    var darkColor = UIColor.red
    var lightColor = UIColor.orange
    let progressTextFont: UIFont = .systemFont(ofSize: 30.0)
    var isShowProgressText = true
    var isAnimated: Bool = true
    
    public var progress: Double = 0.5 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    public var heartAmplitude: Double {
        get {
            return amplitude
        }
        set {
            amplitude = newValue
            self.setNeedsDisplay()
        }
    }
    
    override public func awakeFromNib() {
        animate()
        backgroundColor = .clear
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        animate()
        backgroundColor = .clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func draw(_ rect: CGRect) {
        position = (1 - progress) * Double(rect.height) + (amplitude / 2)
        drawHeartWave(originX: originX - term / 5, fillColor: lightColor)
        drawHeartWave(originX: originX, fillColor: darkColor)
        if isShowProgressText {
            drawProgressText()
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        term =  Double(bounds.size.width) / cycle
    }
    
    override public func removeFromSuperview() {
        super.removeFromSuperview()
        isAnimated = false
    }
    
    func drawHeartWave(originX: Double, fillColor: UIColor) {
        let curvePath = UIBezierPath()
        curvePath.move(to: CGPoint(x: originX, y: position))
        var tempPoint = originX
        for _ in 1...rounding(value: 4 * cycle) {
            curvePath.addQuadCurve(to: keyPoint(x: tempPoint + term / 2, originX: originX),
                                   controlPoint: keyPoint(x: tempPoint + term / 4, originX: originX))
            tempPoint += term / 2
        }
        curvePath.addLine(to: CGPoint(x: curvePath.currentPoint.x, y: self.bounds.size.height))
        curvePath.addLine(to: CGPoint(x: CGFloat(originX), y: self.bounds.size.height))
        curvePath.close()
        fillColor.setFill()
        curvePath.lineWidth = 10
        curvePath.fill()
    }
    
    // swiftlint:disable variable_name
    func keyPoint(x: Double, originX: Double) -> CGPoint {
        return CGPoint(x: x, y: columnYPoint(x: x - originX))
    }
    
    // swiftlint:disable variable_name
    func columnYPoint(x: Double) -> Double {
        let result = amplitude * sin((2 * Double.pi / term) * x + phasePosition)
        return result + position
    }
    
    func drawProgressText() {
        var validProgress = progress * 100
        validProgress = validProgress < 1 ? 0 : validProgress
        let progressText = (NSString(format: "%.0f", validProgress) as String) + "%"
        var attributes: [NSAttributedString.Key: Any] = [.font: progressTextFont]
        if progress > 0.45 {
            attributes.updateValue(UIColor.white, forKey: .foregroundColor)
        } else {
            attributes.updateValue(darkColor, forKey: .foregroundColor)
        }
        let textSize = progressText.size(withAttributes: attributes)
        let textRect = CGRect(x: bounds.width / 2 - textSize.width / 2,
                              y: bounds.height / 2 - textSize.height / 2, width: textSize.width, height: textSize.height)
        progressText.draw(in: textRect, withAttributes: attributes)
    }
    
    func animate() {
//        DispatchQueue.global(qos: .background).async { [weak self]() -> Void in
//            guard let self = self else {
//                return
//            }
//            let tempOriginX = self.originX
//            while self.isAnimated {
//                if self.originX <= tempOriginX - self.term {
//                    self.originX = tempOriginX - self.animationMoveSpan
//                } else {
//                    self.originX -= self.animationMoveSpan
//                }
//                DispatchQueue.main.async(execute: { () -> Void in
//                    self.setNeedsDisplay()
//                })
//                Thread.sleep(forTimeInterval: self.animationUnitTime)
//            }
//        }
    }
    
    func rounding(value: Double) -> Int {
        let tempInt = Int(value)
        let tempDouble = Double(tempInt) + 0.5
        if value > tempDouble {
            return tempInt + 1
        } else {
            return tempInt
        }
    }
}
