//
//  QViewVapeSpendsView.swift
//  Quit
//
//  Created by Alex Tudge on 19/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QViewVapeSpendsView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: VapeSpend.entity(),
        sortDescriptors: []
    ) var vapeSpends: FetchedResults<VapeSpend>
    @Binding var showingDetail: Bool
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vapeSpends, id: \.self) { spend in
                    VStack(alignment: .leading) {
                        Text("\(spend.title ?? "")")
                        Text("\(spend.amount.currencyFormat)")
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationBarTitle("View cravings", displayMode: .inline)
            .navigationBarItems(leading: EditButton())
            .navigationBarItems(trailing: Button(action: {
                showingDetail = false
            }) {
                Text("Done").bold()
            })
        }
    }
}

private extension QViewVapeSpendsView {
    func delete(at offsets: IndexSet) {
        offsets.forEach {
            managedObjectContext.delete(vapeSpends[$0])
        }
        try? managedObjectContext.save()
    }
}

struct QViewVapeSpendsView_Previews: PreviewProvider {
    static var previews: some View {
        QViewVapeSpendsView(showingDetail: .constant(true))
    }
}
