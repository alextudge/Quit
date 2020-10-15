//
//  QCravingsSectionView.swift
//  Quit
//
//  Created by Alex Tudge on 09/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QCravingsSectionView: View {
        
    var body: some View {
        GeometryReader { geo in
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 20) {
                        VStack(spacing: 20) {
                            NavigationLink(destination: QAddCravingView()) {
                                Text("Add Craving")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: geo.size.width * 0.3, height: (geo.size.height / 2) - 10)
                                    .background(Color.green)
                                    .cornerRadius(5)
                            }
                            NavigationLink(destination: QViewCravingsView()) {
                                Text("View Cravings")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: geo.size.width * 0.3, height: (geo.size.height / 2) - 10)
                                    .background(Color.green)
                                    .cornerRadius(5)
                            }
                        }
                        QCravingChartView(chartTitle: "Cravings")
                            .frame(width: geo.size.width * 0.8)
                        QCravingChartView(chartTitle: "Triggers [Wrong data]")
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
