//
//  QFinanceSummaryView.swift
//  Quit
//
//  Created by Alex Tudge on 10/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QFinanceSummaryView: View {
    
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
            Text("\(stringFromCurrencyFormatter(data: costForFinance) ?? "£0")")
                .foregroundColor(.white)
        }
        .padding()
    }
}

private extension QFinanceSummaryView {
    func stringFromCurrencyFormatter(data: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: data))
    }
}

struct QFinanceSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        QFinanceSummaryView(profile: Profile(), finance: .daily)
    }
}
