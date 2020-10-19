//
//  AddCravingIntentHandler.swift
//  AddCravingIntent
//
//  Created by Alex Tudge on 04/06/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import Intents

class AddCravingIntentHandler: NSObject, AddCravingIntentHandling {
    
    private let persistenceManager = PersistenceManager()
    
    func confirm(intent: AddCravingIntent, completion: @escaping (AddCravingIntentResponse) -> Void) {
        guard let smoked = intent.smoked else {
            completion(AddCravingIntentResponse(code: .failure, userActivity: nil))
            return
        }
//        persistenceManager.addCraving(catagory: intent.trigger ?? "", smoked: smoked.boolValue)
        completion(AddCravingIntentResponse(code: .success, userActivity: nil))
    }
    
    func handle(intent: AddCravingIntent, completion: @escaping (AddCravingIntentResponse) -> Void) {
        completion(AddCravingIntentResponse(code: .success, userActivity: nil))
    }
    
    func resolveSmoked(for intent: AddCravingIntent, with completion: @escaping (INBooleanResolutionResult) -> Void) {
        completion(INBooleanResolutionResult.success(with: intent.smoked?.boolValue ?? false))
    }
    
    func resolveTrigger(for intent: AddCravingIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if let trigger = intent.trigger {
            completion(INStringResolutionResult.success(with: trigger))
        } else {
            completion(INStringResolutionResult.notRequired())
        }
    }
}
