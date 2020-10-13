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
        GeometryReader { geo in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20) {
                    ForEach(QFinance.allCases, id: \.self) {
                        QFinanceTimeSavingView(profile: profile, finance: $0)
                            .frame(width: geo.size.width * 0.9)
                            .background(LinearGradient(gradient: Gradient(colors: [.orange, .yellow]), startPoint: .bottomLeading, endPoint: .topTrailing))
                            .cornerRadius(5)
                    }
                }
            }
        }
    }
}

struct QFinanceTimeSavingListView_Previews: PreviewProvider {
    static var previews: some View {
        QFinanceTimeSavingListView(profile: Profile())
    }
}