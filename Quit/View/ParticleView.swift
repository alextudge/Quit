//
//  ParticleView.swift
//  Quit
//
//  Created by Alex Tudge on 31/05/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import UIKit

class ParticleView: UIView {
    
    var particleImage: UIImage?
    var starColour = UIColor.white
    var emissionRange: CGFloat = 360
    
    override class var layerClass: AnyClass {
        return CAEmitterLayer.self
    }
    
    override func layoutSubviews() {
        if let emitter = self.layer as? CAEmitterLayer {
            emitter.emitterShape = .point
            emitter.zPosition = 1
            emitter.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
            emitter.emitterSize = CGSize(width: 1, height: 1)
            let near = makeEmitterCell(color: starColour, velocity: 100, scale: 0.3)
            let middle = makeEmitterCell(color: starColour.withAlphaComponent(0.66), velocity: 80, scale: 0.2)
            let far = makeEmitterCell(color: starColour.withAlphaComponent(0.33), velocity: 60, scale: 0.1)
            emitter.emitterCells = [near, middle, far]
        }
    }
    
    func makeEmitterCell(color: UIColor, velocity: CGFloat, scale: CGFloat) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 10
        cell.lifetime = 20.0
        cell.lifetimeRange = 0
        cell.color = color.cgColor
        cell.velocity = velocity
        cell.velocityRange = velocity / 4
        cell.emissionLongitude = .pi / 4
        cell.emissionRange = emissionRange
        cell.scale = scale
        cell.scaleRange = scale / 3
        cell.contents = particleImage?.cgImage
        return cell
    }
}
