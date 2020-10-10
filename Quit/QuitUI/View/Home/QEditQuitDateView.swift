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
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let date = profile.quitDate {
                    Text(Date().offsetFrom(date: date))
                }
                DatePicker("", selection: .init(get: { (
                    profile.quitDate ?? Date())
                },
                set: {
                    profile.quitDate = $0
                    try? managedObjectContext.save()
                }))
            }
        }.padding()
    }
}

struct QEditQuitDateView_Previews: PreviewProvider {
    static var previews: some View {
        QEditQuitDateView(profile: Profile())
    }
}
