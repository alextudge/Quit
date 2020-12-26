//
//  QButtonStyle.swift
//  Quit
//
//  Created by Alex Tudge on 08/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QButtonStyle: ButtonStyle {
        
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .padding()
            .background(Color.green)
            .foregroundColor(Color.white)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.easeInOut(duration: 0.2))
            .cornerRadius(10)
    }
}
