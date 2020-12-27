//
//  QClockView.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QClockView: View {
    
    var progress: Double
    private var correctedProgress: Double {
        (progress * 360) > 360 ? 360 : (progress * 360)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                PieChartSlide(geo: geometry, startAngle: -90, endAngle: correctedProgress - 90, colour: .white)
                PieChartSlide(geo: geometry, startAngle: correctedProgress - 90, endAngle: 270, colour: .clear)
            }
        }
        .frame(minWidth: 100, minHeight: 100)
    }
}

struct QClockView_Previews: PreviewProvider {
    static var previews: some View {
        QClockView(progress: 0.5)
    }
}

public struct PieChartSlide: View {
    
    @State private var show = false
    
    var geo: GeometryProxy
    var startAngle: Double
    var endAngle: Double
    var colour: Color
    
    var path: Path {
        let radius = min(geo.size.width, geo.size.height) / 2
        var path = Path()
        let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
        path.move(to: center)
        path.addArc(center: center,
                    radius: radius,
                    startAngle: Angle(degrees: startAngle),
                    endAngle: Angle(degrees: endAngle),
                    clockwise: false)
        return path
    }
    
    public var body: some View {
        path
            .fill(colour)
            .overlay(path.stroke(Color.white, lineWidth: 2))
    }
}
