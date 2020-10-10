//
//  QHealineGuageListView.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QHeadlineGuageListView: View {
    
    @ObservedObject var profile: Profile
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20) {
                    ForEach(QGuage.allCases, id: \.self) {
                        QHeadlineGuageListItemView(guage: $0, profile: profile)
                            .frame(width: geo.size.width * 0.8, height: geo.size.height)
                            .background(LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .cornerRadius(5)
                    }
                }
            }
        }
    }
}

struct QHealineGuageListView_Previews: PreviewProvider {
    static var previews: some View {
        QHeadlineGuageListView(profile: Profile())
    }
}
