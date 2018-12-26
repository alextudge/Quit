//
//  AdditionalUserData.swift
//  Quit
//
//  Created by Alex Tudge on 26/12/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import Foundation

struct AdditionalUserData {
    
    var reasonsToSmoke: [String]?
    var reasonsNotToSmoke: [String]?
    
    init(reasonsToSmoke: [String]?, reasonsNotToSmoke: [String]?) {
        self.reasonsToSmoke = reasonsToSmoke
        self.reasonsNotToSmoke = reasonsNotToSmoke
    }
}
