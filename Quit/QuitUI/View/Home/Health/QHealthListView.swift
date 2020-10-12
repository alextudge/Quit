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
        GeometryReader { geo in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20) {
                    ForEach(QHealth.allCases, id: \.self) { healthStat in
                        QHealthView(profile: profile, healthStat: healthStat)
                            .frame(width: geo.size.width * 0.5, height: geo.size.height)
                            .background(LinearGradient(gradient: Gradient(colors: [.red, .orange]), startPoint: .top, endPoint: .bottom))
                            .cornerRadius(5)
                    }
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
