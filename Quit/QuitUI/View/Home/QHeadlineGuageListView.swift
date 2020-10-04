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
                            .background($0.colour)
                            .cornerRadius(5)
                            .shadow(radius: 3)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct QHealineGuageListView_Previews: PreviewProvider {
    static var previews: some View {
        QHeadlineGuageListView(profile: Profile())
    }
}
