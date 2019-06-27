//
//  AddCravingIntentHandler.swift
//  AddCravingIntent
//
//  Created by Alex Tudge on 04/06/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import Foundation

class AddCravingIntentHandler: NSObject, AddCravingIntentHandling {
    
    private let persistenceManager = PersistenceManager()
    
    func confirm(intent: AddCravingIntent, completion: @escaping (AddCravingIntentResponse) -> Void) {
        persistenceManager.addCraving(catagory: "", smoked: false)
        completion(AddCravingIntentResponse(code: .success, userActivity: nil))
    }
    
    func handle(intent: AddCravingIntent, completion: @escaping (AddCravingIntentResponse) -> Void) {
        completion(AddCravingIntentResponse(code: .success, userActivity: nil))
    }
}
