//
//  QHealthView.swift
//  Quit
//
//  Created by Alex Tudge on 12/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QHealthView: View {
    
    @ObservedObject var profile: Profile
    let healthStat: QHealth
    
    var body: some View {
        NavigationLink(destination: QHealthInfoView(healthState: healthStat, profile: profile)) {
            VStack {
                Text(healthStat.title)
                    .foregroundColor(.white)
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                QClockView(progress: Double(profile.secondsSmokeFree ?? 0) / healthStat.secondsForHealthState())
            }
            .padding()
        }
    }
}

struct QHealthView_Previews: PreviewProvider {
    static var previews: some View {
        QHealthView(profile: Profile(), healthStat: .bronchialTubes)
    }
}
