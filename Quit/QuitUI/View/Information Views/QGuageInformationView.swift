//
//  QGuageInformationView.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QGuageInformationView: View {
    
    let guage: QGuage
    
    var body: some View {
        ZStack {
            
        }
        .navigationTitle(guage.nameForHeadline)
    }
}

struct QGuageInformationView_Previews: PreviewProvider {
    static var previews: some View {
        QGuageInformationView(guage: .freeTime)
    }
}
