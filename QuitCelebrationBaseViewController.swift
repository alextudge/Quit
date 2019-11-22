//
//  QuitCelebrationBaseViewController.swift
//  Quit
//
//  Created by Alex Tudge on 14/11/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import UIKit

class QuitCelebrationBaseViewController: QuitBaseViewController {
    private var emitter = CAEmitterLayer()
    private let colors: [UIColor] = [
        UIColor(red: 1.0, green: 0.0, blue: 77.0/255.0, alpha: 1.0),
        UIColor.blue,
        UIColor(red: 35.0/255.0, green: 233/255, blue: 173/255.0, alpha: 1.0),
        UIColor(red: 1, green: 209/255, blue: 77.0/255.0, alpha: 1.0)
    ]
    private let images: [UIImage] = [
        UIImage(named: "Box")!,
        UIImage(named: "Triangle")!,
        UIImage(named: "Circle")!,
        UIImage(named: "Spiral")!
    ]
    private let velocities = [100, 90, 150, 200]
    
    func setupEmitter() {
        let newView = UIView(frame: view!.frame)
        emitter.emitterPosition = CGPoint(x: self.view.frame.size.width / 2, y: -10)
        emitter.emitterShape = CAEmitterLayerEmitterShape.line
        emitter.emitterSize = CGSize(width: self.view.frame.size.width, height: 2.0)
        emitter.emitterCells = generateEmitterCells()
        newView.layer.addSublayer(emitter)
        view.addSubview(newView)
        view.sendSubviewToBack(newView)
    }
    
    @IBAction private func didTapDoneButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}

private extension QuitCelebrationBaseViewController {
    func generateEmitterCells() -> [CAEmitterCell] {
        var cells: [CAEmitterCell] = [CAEmitterCell]()
        for index in 0..<16 {
            let cell = CAEmitterCell()
            cell.birthRate = 4.0
            cell.lifetime = 14.0
            cell.lifetimeRange = 0
            cell.velocity = CGFloat(getRandomVelocity())
            cell.velocityRange = 0
            cell.emissionLongitude = CGFloat(Double.pi)
            cell.emissionRange = 0.5
            cell.spin = 3.5
            cell.spinRange = 0
            cell.color = getNextColor(index: index)
            cell.contents = getNextImage(index: index)
            cell.scaleRange = 0.25
            cell.scale = 0.1
            cells.append(cell)
        }
        return cells
        
    }
    
    func getRandomVelocity() -> Int {
        return velocities[getRandomNumber()]
    }
    
    func getRandomNumber() -> Int {
        return Int(arc4random_uniform(4))
    }
    
    func getNextColor(index: Int) -> CGColor {
        if index <= 4 {
            return colors[0].cgColor
        } else if index <= 8 {
            return colors[1].cgColor
        } else if index <= 12 {
            return colors[2].cgColor
        } else {
            return colors[3].cgColor
        }
    }
    
    func getNextImage(index: Int) -> CGImage {
        return images[index % 4].cgImage!
    }
}
