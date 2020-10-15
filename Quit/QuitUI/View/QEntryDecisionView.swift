//
//  QEntryDecisionView.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QEntryDecisionView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Profile.entity(), sortDescriptors: []) var profiles: FetchedResults<Profile>
    
    var body: some View {
        NavigationView {
            if let profile = profiles.first {
                QHomeView(profile: profile)
            } else {
                QUnregisteredUserView()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct QEntryDecisionView_Previews: PreviewProvider {
    static var previews: some View {
        QEntryDecisionView()
    }
}
