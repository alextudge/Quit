//
//  QHealthInfoView.swift
//  Quit
//
//  Created by Alex Tudge on 12/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QHealthInfoView: View {
    
    let healthState: QHealth
    let profile: Profile
    private var progress: Double {
        let percentage = Double(profile.secondsSmokeFree ?? 0) / healthState.secondsForHealthState() * 100
        return percentage > 100 ? 100 : percentage
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("\(String(format: "%.0f", progress))%")
                    .font(.headline)
                Text(healthState.information())
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .navigationTitle(healthState.title)
    }
}

struct QHealthInfoView_Previews: PreviewProvider {
    static var previews: some View {
        QHealthInfoView(healthState: .fertility, profile: Profile())
    }
}
