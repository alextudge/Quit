//
//  QFinanceSummaryView.swift
//  Quit
//
//  Created by Alex Tudge on 10/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QFinanceTimeSavingView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var profile: Profile
    var finance: QFinance
    private var costForFinance: Double {
        profile.costPerMinute * Double(finance.minutesForPeriod(minutesSmokeFree: profile.minutesSmokeFree))
    }
    
    var body: some View {
        VStack {
            Text(finance.title)
                .font(.headline)
                .foregroundColor(.white)
            Text("\(costForFinance.currencyFormat)")
                .foregroundColor(.white)
        }
        .padding()
    }
}

struct QFinaceTimeSavingView_Previews: PreviewProvider {
    static var previews: some View {
        QFinanceTimeSavingView(profile: Profile(), finance: .daily)
    }
}
