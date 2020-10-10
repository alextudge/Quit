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
                Button("Add craving", action: {
                    addingCraving = 1
                })
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
