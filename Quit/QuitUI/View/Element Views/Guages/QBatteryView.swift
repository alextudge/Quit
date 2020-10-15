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
        if progress > 1 {
            return 1
        } else if progress < 0 {
            return 0
        }
        return progress
    }
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                Spacer()
                VStack(alignment: .center) {
                    Rectangle()
                        .fill(Color.white)
                        .cornerRadius(10)
                        .frame(width: geo.size.width * 0.3, height: geo.size.height * 0.04)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.white, lineWidth: 5)
                        )
                    ZStack {
                        GeometryReader { subGeo in
                            Rectangle()
                                .fill(Color.white)
                                .cornerRadius(5)
                                .frame(height: subGeo.size.height * CGFloat(correctedProgress))
                                .offset(y: subGeo.size.height - subGeo.size.height * CGFloat(correctedProgress))
                            Rectangle()
                                .fill(Color.clear)
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                        }
                    }
                    .frame(width: geo.size.width * 0.5, height: geo.size.height * 0.95)
                }
                Spacer()
            }
        }
    }
}

struct QBatteryView_Previews: PreviewProvider {
    static var previews: some View {
        QBatteryView(progress: 0.25)
    }
}
