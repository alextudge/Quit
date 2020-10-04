//
//  QHomeView.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QHomeView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var profile: Profile
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 20) {
                    Text("Highlights")
                    QHeadlineGuageListView(profile: profile)
                        .frame(height: geo.size.height * 0.4)
                    QEditQuitDateView(profile: profile)
                    Text("Your cravings")
                    QCravingChartView()
                        .frame(height: geo.size.height * 0.4)
                }
            }
        }
        .navigationBarItems(leading:
            Button("Delete", action: {
                managedObjectContext.delete(profile)
                try? managedObjectContext.save()
            })
        )
    }
}

struct QHomeView_Previews: PreviewProvider {
    static var previews: some View {
        QHomeView(profile: Profile())
    }
}
