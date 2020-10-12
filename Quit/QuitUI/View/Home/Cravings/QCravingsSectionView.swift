//
//  QCravingsSectionView.swift
//  Quit
//
//  Created by Alex Tudge on 09/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QCravingsSectionView: View {
    
    @State private var addingCraving: Int?
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                NavigationLink(destination: QAddCravingView(), tag: 1, selection: $addingCraving) {
                    EmptyView()
                }
                NavigationLink(destination: QViewCravingsView(), tag: 2, selection: $addingCraving) {
                    EmptyView()
                }
                HStack {
                    Button("Add craving", action: {
                        addingCraving = 1
                    })
                    .buttonStyle(QButtonStyle())
                    Spacer()
                    Button("View cravings", action: {
                        addingCraving = 2
                    })
                    .buttonStyle(QButtonStyle())
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 20) {
                        QCravingChartView()
                            .frame(width: geo.size.width * 0.8)
                        QCravingChartView()
                            .frame(width: geo.size.width * 0.8)
                    }
                }
            }
        }
    }
}

struct QCravingsSectionView_Previews: PreviewProvider {
    static var previews: some View {
        QCravingsSectionView()
    }
}
