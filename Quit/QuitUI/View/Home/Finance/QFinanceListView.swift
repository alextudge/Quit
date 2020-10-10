//
//  QFinanceListView.swift
//  Quit
//
//  Created by Alex Tudge on 10/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QFinanceListView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var profile: Profile
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20) {
                    ForEach(QFinance.allCases, id: \.self) {
                        QFinanceSummaryView(profile: profile, finance: $0)
                            .frame(height: geo.size.height)
                            .background(LinearGradient(gradient: Gradient(colors: [.orange, .yellow]), startPoint: .bottomLeading, endPoint: .topTrailing))
                            .cornerRadius(5)
                    }
                }
            }
        }
    }
}

struct QFinanceListView_Previews: PreviewProvider {
    static var previews: some View {
        QFinanceListView(profile: Profile())
    }
}
