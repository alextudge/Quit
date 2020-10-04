//
//  QCravingChartView.swift
//  Quit
//
//  Created by Alex Tudge on 03/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QCravingChartView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: Craving.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "cravingSmoked = %d", false)
    ) var cravings: FetchedResults<Craving>
    @State private var chartHasAppeared = false
    
    var body: some View {
        VStack(alignment: .leading) {
            QLineGraph(dataPoints: processedCravings())
                .trim(to: chartHasAppeared ? 1 : 0)
                .stroke(LinearGradient(gradient: Gradient(colors: [.orange, .green]), startPoint: .top, endPoint: .bottom), lineWidth: 2)
            HStack {
                if let min = cravings.map { ($0.cravingDate ?? Date()) }.min(),
                   let max = cravings.map { ($0.cravingDate ?? Date()) }.max() {
                    Text("\(stringDate(date: min))")
                    Spacer()
                    Text("\(stringDate(date: max))")
                }
            }
        }
        .padding()
        .onAppear {
            withAnimation(.easeInOut(duration: 2)) {
                chartHasAppeared = true
            }
        }
    }
}

private extension QCravingChartView {
    func processedCravings() -> [Date : Int] {
        var cravingDict = [Date: Int]()
        cravings.forEach {
            let date = standardisedDate(date: $0.cravingDate ?? Date())
            cravingDict[date] = cravingDict[date] == nil ? 1 : cravingDict[date]! + 1
        }
        return cravingDict
    }
    
    func stringDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    func standardisedDate(date: Date) -> Date {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        let stringDate = formatter.string(from: date)
        return formatter.date(from: stringDate)!
    }
}

struct QCravingChartView_Previews: PreviewProvider {
    static var previews: some View {
        QCravingChartView()
    }
}
