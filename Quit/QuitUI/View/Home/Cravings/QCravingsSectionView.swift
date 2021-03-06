//
//  QCravingsSectionView.swift
//  Quit
//
//  Created by Alex Tudge on 09/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QCravingsSectionView: View {
    
    @ObservedObject var profile: Profile
    @FetchRequest(
        entity: Craving.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "cravingSmoked = %d", false)
    ) var cravings: FetchedResults<Craving>
        
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 10) {
                    NavigationLink(destination: QAddCravingView(profile: profile)) {
                        Text("Add Craving")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("section5"))
                            .cornerRadius(5)
                    }
                    NavigationLink(destination: QViewCravingsView()) {
                        Text("View Cravings")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("section5"))
                            .cornerRadius(5)
                    }
                }
                if !cravings.isEmpty {
                    QCravingChartView(chartTitle: "Cravings")
                } else {
                    Text("Your cravings chart will appear here.")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color("section5"))
                        .cornerRadius(5)
                }
            }
            .padding(.horizontal)
            .shadow(radius: 5)
        }
    }
}

struct QCravingsSectionView_Previews: PreviewProvider {
    static var previews: some View {
        QCravingsSectionView(profile: Profile())
    }
}
