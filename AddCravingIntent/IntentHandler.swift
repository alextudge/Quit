//
//  IntentHandler.swift
//  AddCravingIntent
//
//  Created by Alex Tudge on 04/06/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        guard intent is AddCravingIntent else {
            fatalError()
        }
        
        return AddCravingIntentHandler()
    }
    
}
