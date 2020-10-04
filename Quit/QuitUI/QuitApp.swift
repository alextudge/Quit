//
//  QuitApp.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

@main
struct ScreenMakerApp: App {
    
    let persistenceManager = PersistenceManager()
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            QEntryDecisionView()
                .environment(\.managedObjectContext, persistenceManager.persistentContainer.viewContext)
        }
    }
    
    func saveContext () {
        let context = persistenceManager.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {}
        }
    }
}
