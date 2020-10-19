//
//  QSetupProfileView.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QSetupProfileView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var quitDate: Date
    @State private var numberSmoked = ""
    @State private var costOf20 = ""
    @State private var notificationsEnabled = false
    @State private var showingAlert = false
    var profile: Profile?
    
    init(profile: Profile?) {
        self.profile = profile
        _quitDate = State(initialValue: profile?.quitDate ?? Date())
        _numberSmoked = State(initialValue: profile?.smokedDaily?.stringValue ?? "")
        _costOf20 = State(initialValue: profile?.costOf20?.stringValue ?? "")
        _notificationsEnabled = State(initialValue: profile?.notificationsEnabled ?? false)
    }
    
    var body: some View {
        Form {
            DatePicker("When are you looking to quit?", selection: $quitDate)
            TextField("How many do you smoke daily?", text: $numberSmoked)
                .keyboardType(.numberPad)
            TextField("How much is a pack of 20?", text: $costOf20)
                .keyboardType(.decimalPad)

            Toggle("Send notifcations", isOn: $notificationsEnabled)
            Button("Save", action: {
                if !numberSmoked.isNumber || !costOf20.isNumber {
                    showingAlert = true
                } else {
                    save()
                }
            })
            .buttonStyle(QButtonStyle())
            Text("None of this data is shared with any third party services, or stored on any remote servers; it's your data. It's shared accross your Apple devices using Apple's iCloud, which you can manage using your device's settings.")
                .font(.footnote)
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("🤕"), message: Text("Both text fields are required, and must contain numbers only."), dismissButton: .default(Text("Got it!")))
        }
        .onChange(of: notificationsEnabled) { newValue in
            QNotificationManager().requestNotificationPermissions()
        }
    }
}

private extension QSetupProfileView {
    func save() {
        let profile = self.profile ?? Profile(context: managedObjectContext)
        profile.quitDate = quitDate
        profile.smokedDaily = NSNumber(value: Int(numberSmoked) ?? 0)
        profile.costOf20 = NSNumber(value: Double(costOf20) ?? 0.0)
        profile.notificationsEnabled = notificationsEnabled
        QNotificationManager().cancelAllNotifications()
        if notificationsEnabled {
            QNotificationManager().setupHealthNotifications(quitDate: quitDate)
        }
        try? managedObjectContext.save()
        presentationMode.wrappedValue.dismiss()
    }
}

struct QSetupProfileView_Previews: PreviewProvider {
    static var previews: some View {
        QSetupProfileView(profile: nil)
    }
}
