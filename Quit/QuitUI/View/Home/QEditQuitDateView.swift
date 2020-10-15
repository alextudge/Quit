//
//  QEditQuitDateView.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QEditQuitDateView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var profile: Profile
    @State private var showTimer = false
    @State private var countdownTimer = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(countdownTimer)
                    .onReceive(timer) { _ in
                        countdownTimer = Date().offsetFrom(date: profile.quitDate ?? Date())
                    }
                DatePicker("", selection: .init(get: { (
                    profile.quitDate ?? Date())
                },
                set: {
                    profile.quitDate = $0
                    try? managedObjectContext.save()
                }))
            }
        }
        .padding()
        .background(Color(UIColor.tertiarySystemBackground))
        .cornerRadius(5)
    }
}

struct QEditQuitDateView_Previews: PreviewProvider {
    static var previews: some View {
        QEditQuitDateView(profile: Profile())
    }
}
