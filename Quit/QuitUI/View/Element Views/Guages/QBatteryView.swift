//
//  QBatteryView.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QBatteryView: View {
        
    var progress: Double
    private var correctedProgress: Double {
        progress > 1 ? 1 : progress
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center) {
                Rectangle()
                    .fill(Color.white)
                    .cornerRadius(10)
                    .frame(width: geo.size.width * 0.3, height: geo.size.height * 0.04)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 5)
                    )
                ZStack {
                    GeometryReader { subGeo in
                        Rectangle()
                            .fill(Color.green)
                            .cornerRadius(10)
                            .frame(height: subGeo.size.height * CGFloat(correctedProgress))
                            .offset(y: subGeo.size.height - subGeo.size.height * CGFloat(correctedProgress))
                        Rectangle()
                            .fill(Color.clear)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 10)
                            )
                    }
                }
                .frame(width: geo.size.width * 0.5, height: geo.size.height * 0.95)
            }
        }
    }
}

struct QBatteryView_Previews: PreviewProvider {
    static var previews: some View {
        QBatteryView(progress: 0.25)
    }
}
