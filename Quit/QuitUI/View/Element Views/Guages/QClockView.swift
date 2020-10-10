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
                PieChartSlide(geometry: geometry, startAngle: -90, endAngle: correctedProgress - 90, colour: .white)
                PieChartSlide(geometry: geometry, startAngle: correctedProgress - 90, endAngle: 270, colour: .clear)
            }
        }
    }
}

struct QClockView_Previews: PreviewProvider {
    static var previews: some View {
        QClockView(progress: 0.5)
    }
}

public struct PieChartSlide: View {
    
    @State private var show = false
    
    var geometry: GeometryProxy
    var startAngle: Double
    var endAngle: Double
    var colour: Color
    
    var path: Path {
        let radius = geometry.size.width / 3
        var path = Path()
        path.move(to: CGPoint(x: radius, y: radius))
        path.addArc(center: CGPoint(x: radius, y: radius),
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
