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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var profile: Profile
    private let purchaseHelper = QPurchaseHelper()
    
    var body: some View {
        List {
            Button("Delete everything", action: {
                deleteProfile()
            })
            NavigationLink(destination: QSetupProfileView(profile: profile)) {
                Text("Edit profile")
            }
            if !profile.isPro && purchaseHelper.canMakePayments {
                NavigationLink(destination: QPurchaseProView()) {
                    Text("Go pro")
                }
                Button("Restore purchases", action: {
                    purchaseHelper.restorePurchases()
                })
            }
        }
        .navigationTitle("Settings")
    }
}

private extension QSettingsView {
    func deleteProfile() {
        PersistenceManager().deleteEverything()
        QNotificationManager().cancelAllAutomaticNotifications()
        presentationMode.wrappedValue.dismiss()
    }
}

struct QSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        QSettingsView(profile: Profile())
    }
}
