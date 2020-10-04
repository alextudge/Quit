//
//  SectionThreeTriggerChartCell.swift
//  Quit
//
//  Created by Alex Tudge on 09/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class SectionThreeTriggerChartCell: UICollectionViewCell {
    
    @IBOutlet private weak var roundedView: RoundedView!
    
    private var persistenceManager: PersistenceManager?
    
    func setup(persistenceManager: PersistenceManager?) {
        self.persistenceManager = persistenceManager
    }
}

private extension SectionThreeTriggerChartCell {
    
    func randomColor() -> UIColor {
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 0.8)
    }
}
