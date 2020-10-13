//
//  QSettingsView.swift
//  Quit
//
//  Created by Alex Tudge on 08/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QSettingsView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var profile: Profile
    
    var body: some View {
        List {
            Button("Delete everything", action: {
                managedObjectContext.delete(profile)
                try? managedObjectContext.save()
            })
        }
        .navigationTitle("Settings")
    }
}

private extension QSettingsView {
    func deleteProfile() {
        managedObjectContext.delete(profile)
        try? managedObjectContext.save()
    }
}

struct QSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        QSettingsView(profile: Profile())
    }
}
