//
//  QVapeSpendView.swift
//  Quit
//
//  Created by Alex Tudge on 19/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QVapeSpendView: View {
    
    private enum ActiveSheet {
        case add, all
    }
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: VapeSpend.entity(),
        sortDescriptors: []
    ) var vapeSpends: FetchedResults<VapeSpend>
    @ObservedObject var profile: Profile
    private var totalVapeSpend: Double {
        vapeSpends.reduce(0, { $0 + $1.amount})
    }
    private var savedByVaping: Double {
        profile.savedSoFar - totalVapeSpend
    }
    
    var body: some View {
        if savedByVaping > 0 {
            Text("Compared to smoking, you've saved \(savedByVaping.currencyFormat)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .padding()
                .background(Color("section6"))
                .cornerRadius(5)
                .shadow(radius: 5)
        }
        NavigationLink(destination:  QAddVapeSpendView()) {
            Text("+ spending")
                .foregroundColor(.white)
                .padding()
                .background(Color("section6"))
                .cornerRadius(5)
        }
        .padding(.vertical)
        NavigationLink(destination:  QViewVapeSpendsView()) {
            Text("View all")
                .foregroundColor(.white)
                .padding()
                .background(Color("section6"))
                .cornerRadius(5)
        }
        .padding(.vertical)
        .onAppear {
            translateOldModel()
        }
    }
}

private extension QVapeSpendView {
    func translateOldModel() {
        guard let vapeSpend = profile.vapeSpending else {
            return
        }
        let newVapeSpend = VapeSpend(context: managedObjectContext)
        newVapeSpend.title = ""
        newVapeSpend.amount = vapeSpend.doubleValue
        profile.vapeSpending = nil
        try? managedObjectContext.save()
    }
}

struct QVapeSpendView_Previews: PreviewProvider {
    static var previews: some View {
        QVapeSpendView(profile: Profile())
    }
}
