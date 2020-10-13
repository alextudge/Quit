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
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct QHealthInfoView_Previews: PreviewProvider {
    static var previews: some View {
        QHealthInfoView(healthState: .fertility)
    }
}
