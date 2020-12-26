//
//  QHealthListView.swift
//  Quit
//
//  Created by Alex Tudge on 12/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QHealthListView: View {
    
    @ObservedObject var profile: Profile
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                ForEach(QHealth.allCases, id: \.self) { healthStat in
                    QHealthView(profile: profile, healthStat: healthStat)
                        .background(Color("section7"))
                        .cornerRadius(5)
                        .padding([.leading])
                        .shadow(radius: 5)
                }
            }
        }
    }
}

struct QHealthListView_Previews: PreviewProvider {
    static var previews: some View {
        QHealthListView(profile: Profile())
    }
}
