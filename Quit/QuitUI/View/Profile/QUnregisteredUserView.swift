//
//  QCreateProfileView.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QUnregisteredUserView: View {
    var body: some View {
        List {
            NavigationLink(destination: QSetupProfileView(profile: nil)) {
                Text("Setup")
            }
        }
        .navigationBarTitle("👋", displayMode: .inline)
    }
}

struct QCreateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        QUnregisteredUserView()
    }
}
