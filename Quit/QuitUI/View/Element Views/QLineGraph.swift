//
//  QLineGraph.swift
//  Quit
//
//  Created by Alex Tudge on 04/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QLineGraph: Shape {
    
    var dataPoints: [Date: Int]
    private var datePointValues: [CGFloat] {
        let sortedDataPoints = dataPoints.sorted { $0.key < $1.key}
        return sortedDataPoints.map { CGFloat($0.value) }
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            guard dataPoints.count > 1 else { return }
            path.move(to: CGPoint(x: 0, y: (rect.height / (datePointValues.max() ?? 0)) * CGFloat(datePointValues[0])))
            datePointValues.indices.forEach {
                path.addLine(to: point(at: $0, rect: rect))
            }
        }
    }
}

private extension QLineGraph {
    func point(at index: Int, rect: CGRect) -> CGPoint {
        let x = (rect.width / CGFloat(dataPoints.count - 1)) * CGFloat(index)
        let y = (rect.height / (datePointValues.max() ?? 0)) * CGFloat(datePointValues[index])
        return CGPoint(x: x, y: y)
    }
}

struct QLineGraph_Previews: PreviewProvider {
    static var previews: some View {
        QLineGraph(dataPoints: [:])
    }
}
