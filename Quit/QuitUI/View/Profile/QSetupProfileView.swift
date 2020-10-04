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
    @State var quitDate = Date()
    @State var numberSmoked = ""
    @State var costOf20 = ""
    
    var body: some View {
        Form {
            DatePicker("When are you looking to quit?", selection: $quitDate)
            TextField("How many do you smoke daily?", text: $numberSmoked)
                .keyboardType(.numberPad)
            TextField("How much is a pack of 20?", text: $costOf20)
                .keyboardType(.decimalPad)
            Button("Save", action: {
                save()
            })
            Text("None of this data is pushed to any third party servers; it's your data. It is shared accross Apple devices you're logged into using Apple's iCloud, which you can manage using your device settings.")
                .font(.footnote)
        }
    }
}

private extension QSetupProfileView {
    func save() {
        let profile = Profile(context: managedObjectContext)
        profile.quitDate = quitDate
        profile.smokedDaily = NSNumber(value: Int(numberSmoked) ?? 0)
        profile.costOf20 = NSNumber(value: Double(costOf20) ?? 0.0)
        try? managedObjectContext.save()
    }
}

struct QSetupProfileView_Previews: PreviewProvider {
    static var previews: some View {
        QSetupProfileView()
    }
}
