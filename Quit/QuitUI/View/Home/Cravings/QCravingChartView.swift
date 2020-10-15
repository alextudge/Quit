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
    let chartTitle: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(chartTitle)
                .font(.headline)
                .foregroundColor(.white)
            QLineGraph(dataPoints: processedCravings())
                .trim(to: chartHasAppeared ? 1 : 0)
                .stroke(Color.white, lineWidth: 2)
            HStack {
                if let min = cravings.map { ($0.cravingDate ?? Date()) }.min() {
                    Text("\(stringDate(date: min))")
                        .foregroundColor(.white)
                    Spacer()
                    Text("Now")
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color("quitSecondaryColor"), .green]), startPoint: .topTrailing, endPoint: .bottomLeading))
        .cornerRadius(5)
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
        QCravingChartView(chartTitle: "")
    }
}
