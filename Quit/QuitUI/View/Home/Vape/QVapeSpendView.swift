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
    @State private var showingDetail = false
    @State private var activeSheet: ActiveSheet = .add
    @ObservedObject var profile: Profile
    private var totalVapeSpend: Double {
        vapeSpends.reduce(0, { $0 + $1.amount})
    }
    private var savedByVaping: Double {
        profile.savedSoFar - totalVapeSpend
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if savedByVaping > 0 {
                Text("Compared to smoking, you've saved \(savedByVaping.currencyFormat)")
            }
            HStack {
                Button("+", action: {
                    activeSheet = .add
                    showingDetail.toggle()
                })
                .buttonStyle(QButtonStyle())
                Button("View all", action: {
                    activeSheet = .all
                    showingDetail.toggle()
                })
                .buttonStyle(QButtonStyle())
            }
        }
        .padding()
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(5)
        .sheet(isPresented: $showingDetail) {
            if activeSheet == .add {
                QAddVapeSpendView(showingDetail: $showingDetail)
            } else {
                QViewVapeSpendsView(showingDetail: $showingDetail)
            }
        }
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
