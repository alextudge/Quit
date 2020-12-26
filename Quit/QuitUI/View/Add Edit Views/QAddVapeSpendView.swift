//
//  QAddVapeSpendView.swift
//  Quit
//
//  Created by Alex Tudge on 19/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QAddVapeSpendView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @State var title = ""
    @State var amount = ""
    
    var body: some View {
        Form {
            TextField("What did you spend on?", text: $title)
            TextField("How much did you spend?", text: $amount)
                .keyboardType(.numberPad)
            Button("Save vape spend", action: {
                addVapeSpend()
            })
            .buttonStyle(QButtonStyle())
        }
        .navigationBarTitle("Add vape spend")
    }
}

private extension QAddVapeSpendView {
    func addVapeSpend() {
        let vapeSpend = VapeSpend(context: managedObjectContext)
        vapeSpend.title = title
        vapeSpend.amount = Double(amount) ?? 0
        try? managedObjectContext.save()
        presentationMode.wrappedValue.dismiss()
    }
}

struct QAddVapeSpendView_Previews: PreviewProvider {
    static var previews: some View {
        QAddVapeSpendView()
    }
}
