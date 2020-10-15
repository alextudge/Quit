//
//  QStringExtensions.swift
//  Quit
//
//  Created by Alex Tudge on 15/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import Foundation

extension String {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
