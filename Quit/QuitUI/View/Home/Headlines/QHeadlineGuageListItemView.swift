//
//  QHeadlineGuageListItemView.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QHeadlineGuageListItemView: View {
    
    @State var guage: QGuage
    @ObservedObject var profile: Profile
    
    var body: some View {
        NavigationLink(destination: QGuageInformationView(guage: guage)) {
            VStack(alignment: .center) {
                Text(guage.nameForHeadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .font(.headline)
                Spacer()
                viewForGuage(guage, profile: profile)
                    .padding()
            }.padding()
        }
    }
    
    func viewForGuage(_ guage: QGuage, profile: Profile) -> AnyView {
        switch guage {
        case .overallHealth:
            return AnyView(QBatteryView(progress: guage.progress(profile: profile)))
        case .oneDay, .freeTime:
            return AnyView(QClockView(progress: guage.progress(profile: profile)))
        case .finance:
            return AnyView(QBankNoteView(progress: guage.progress(profile: profile)))
        }
    }
}

struct QHeadlineGuageListItemView_Previews: PreviewProvider {
    static var previews: some View {
        QHeadlineGuageListItemView(guage: .finance, profile: Profile())
    }
}
