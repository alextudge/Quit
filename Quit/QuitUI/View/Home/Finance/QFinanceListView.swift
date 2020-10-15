//
//  QFinanceListView.swift
//  Quit
//
//  Created by Alex Tudge on 10/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QFinanceListView: View {
    
    @ObservedObject var profile: Profile
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 20) {
                QFinanceTimeSavingListView(profile: profile)
                    .frame(height: geo.size.height * 0.3)
                QFinanceSavingGoalListView(profile: profile)
            }
        }
    }
}

struct QFinanceListView_Previews: PreviewProvider {
    static var previews: some View {
        QFinanceListView(profile: Profile())
    }
}
