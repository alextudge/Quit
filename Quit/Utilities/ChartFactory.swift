//
//  ChartFactory.swift
//  Quit
//
//  Created by Alex Tudge on 26/05/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import Foundation
import Charts

class ChartFactory {
    
    var barChart: BarChartView?
    
    func generateBarChart(width: CGFloat, height: CGFloat) -> BarChartView {
        
        barChart = BarChartView()
        
        barChart?.frame = CGRect(x: 0, y: 0, width: width, height: height)
        let xAxis = barChart?.xAxis
        let leftAxis = barChart?.leftAxis
        let rightAxis = barChart?.rightAxis
        //No data formatting
        barChart?.noDataText = "No cravings!"
        barChart?.noDataFont = UIFont(name: "AvenirNext-Bold", size: 20)
        barChart?.noDataTextColor = .white
        //Formatting the x (date) axis
        xAxis?.labelPosition = .bottom
        xAxis?.drawLabelsEnabled = true
        xAxis?.drawLimitLinesBehindDataEnabled = true
        xAxis?.avoidFirstLastClippingEnabled = true
        xAxis?.drawGridLinesEnabled = false
        xAxis?.labelTextColor = .white
        xAxis?.setLabelCount(2, force: true)
        xAxis?.avoidFirstLastClippingEnabled = true
        xAxis?.labelFont = UIFont(name: "AvenirNext-Bold", size: 15)!
        xAxis?.axisLineColor = .white
        xAxis?.axisLineWidth = 2.5
        //Setup other UI elements
        leftAxis?.setLabelCount(2, force: true)
        leftAxis?.axisMinimum = 0
        leftAxis?.drawGridLinesEnabled = false
        rightAxis?.drawAxisLineEnabled = false
        leftAxis?.drawAxisLineEnabled = false
        rightAxis?.drawLabelsEnabled = false
        leftAxis?.labelTextColor = .white
        rightAxis?.drawGridLinesEnabled = false
        barChart?.backgroundColor = .clear
        barChart?.legend.textColor = .white
        barChart?.legend.font = UIFont(name: "AvenirNext-Bold", size: 15)!
        barChart?.chartDescription?.text = ""
        barChart?.highlightPerTapEnabled = false
        leftAxis?.labelFont = UIFont(name: "AvenirNext-Bold", size: 15)!
        barChart?.isUserInteractionEnabled = false
        return barChart!
    }
    
    func updateCravingData(cravingDict: [Date: Int], smokedDict: [Date: Int], catagoryDict: [String: Int]) -> NSAttributedString? {
        
        guard barChart != nil else { return nil }
        
        //Setup chart
        
        var referenceTimeInterval: TimeInterval = 0
        if let minTimeInterval = (cravingDict.map { $0.key.timeIntervalSince1970 }).min() {
            referenceTimeInterval = minTimeInterval
        }
        let xValuesNumberFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval,
                                                         dateFormatter: mediumDateFormatter())
        barChart!.xAxis.valueFormatter = xValuesNumberFormatter
        var entries = [BarChartDataEntry]()
        
        for x in cravingDict {
            let timeInerval = x.key.timeIntervalSince1970
            let xValue = (timeInerval - referenceTimeInterval) / (3600 * 24)
            let cravingCount = x.value
            let smokedCount = (smokedDict[x.key] == nil) ? 0 : smokedDict[x.key]
            let entry = BarChartDataEntry(x: xValue, yValues: [Double(cravingCount), Double(smokedCount!)])
            entries.append(entry)
        }
        
        entries.sort(by: {$0.x < $1.x})
        let barChartSet = BarChartDataSet(values: entries, label: "")
        barChartSet.colors = [UIColor.white, UIColor.red]
        barChartSet.stackLabels = ["Cravings", "Smoked"]
        barChartSet.drawValuesEnabled = false
        let data = BarChartData(dataSets: [barChartSet])
        barChart!.data = data
        barChart!.notifyDataSetChanged()
        let sortedDict = catagoryDict.sorted(by: { $0.value > $1.value })
        var string = "Triggers\n"
        for x in sortedDict {
            guard x.key != "" else { continue }
            string += "\(x.key): \(x.value)\n"
        }
        
        let attString = [NSAttributedStringKey.foregroundColor: UIColor.white,
                         NSAttributedStringKey.font: UIFont(name: "AvenirNext-Bold", size: 30)!]
        return NSAttributedString(string: string, attributes: attString)
    }
    
    func mediumDateFormatter() -> DateFormatter {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    func generateProgressView() -> KDCircularProgress {
        
        let progress = KDCircularProgress()
        progress.startAngle = -90
        progress.isUserInteractionEnabled = true
        progress.progressThickness = 0.6
        progress.trackThickness = 0.6
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = false
        progress.glowMode = .forward
        progress.trackColor = .lightGray
        progress.glowAmount = 0.5
        progress.set(colors: Constants.greenColour)
        return progress
    }
}
