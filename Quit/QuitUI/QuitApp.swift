//
//  QuitApp.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

//Add back reasons to smoke and quit

import SwiftUI

@main
struct ScreenMakerApp: App {
    
    private let persistenceManager = PersistenceManager()
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            QEntryDecisionView()
                .environment(\.managedObjectContext, persistenceManager.persistentContainer.viewContext)
        }
    }
}
