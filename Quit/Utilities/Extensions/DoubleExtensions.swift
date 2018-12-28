//
//  DoubleExtensions.swift
//  Quit
//
//  Created by Alex Tudge on 28/12/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import Foundation

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
