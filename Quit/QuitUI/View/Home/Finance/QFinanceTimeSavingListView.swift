//
//  QFinanceTimeSavingListView.swift
//  Quit
//
//  Created by Alex Tudge on 12/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QFinanceTimeSavingListView: View {
    
    @ObservedObject var profile: Profile
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(QFinance.allCases, id: \.self) {
                    QFinanceTimeSavingView(profile: profile, finance: $0)
                }
            }.padding()
        }
    }
}

struct QFinanceTimeSavingListView_Previews: PreviewProvider {
    static var previews: some View {
        QFinanceTimeSavingListView(profile: Profile())
    }
}
