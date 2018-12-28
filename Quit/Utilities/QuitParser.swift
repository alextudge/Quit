//
//  QuitParser.swift
//  Quit
//
//  Created by Alex Tudge on 26/12/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import Foundation

class QuitParser {
    func parseQuitData(quitData: [String: Any]) -> QuitData {
        let smokedDaily = quitData[Constants.QuitDataConstants.smokedDaily] as? Int
        let costOf20 = quitData[Constants.QuitDataConstants.costOf20] as? Double
        let quitDate = quitData[Constants.QuitDataConstants.quitDate] as? Date
        let vapeSpending = quitData[Constants.QuitDataConstants.vapeSpending] as? Double
        return QuitData(smokedDaily: smokedDaily,
                        costOf20: costOf20,
                        quitDate: quitDate,
                        vapeSpending: vapeSpending)
    }
    
    func parseAdditionalUserData(data: [String: Any]) -> AdditionalUserData {
        let reasonsToSmoke = data[Constants.AdditionalUserDataConstants.reasonsToSmoke] as? [String]
        let reasonsNotToSmoke = data[Constants.AdditionalUserDataConstants.reasonsNotToSmoke] as? [String]
        return AdditionalUserData(reasonsToSmoke: reasonsToSmoke,
                                  reasonsNotToSmoke: reasonsNotToSmoke)
    }
}