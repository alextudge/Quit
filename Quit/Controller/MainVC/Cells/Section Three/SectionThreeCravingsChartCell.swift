//
//  SectionThreeCravingsChartCell.swift
//  Quit
//
//  Created by Alex Tudge on 06/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit
import Charts

class SectionThreeCravingsChartCell: UICollectionViewCell {
    
    @IBOutlet weak var roundedView: RoundedView!
    @IBOutlet weak var barChart: BarChartView!
    
    private var gradientLayer: CAGradientLayer?
    var persistenceManager: PersistenceManager? {
        didSet {
            guard persistenceManager != nil else {
                return
            }
            loadBarChartData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        roundedView.frame = CGRect(x: CGFloat(5),
                                   y: CGFloat(5),
                                   width: UIScreen.main.bounds.width - 10,
                                   height: UIScreen.main.bounds.height / 2.3 - 10)
        roundedView.layer.cornerRadius = 10
        gradientLayer = roundedView.gradient(colors: Constants.Colours.grayGradient.reversed())
        formatBarChart()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = roundedView.bounds
        gradientLayer?.cornerRadius = roundedView.layer.cornerRadius
    }
    
    func reloadBarChart() {
        barChart.notifyDataSetChanged()
        barChart.data?.notifyDataChanged()
    }
    
    private func loadBarChartData() {
        guard let cravingData = persistenceManager?.cravings else {
            return
        }
        var referenceTimeInterval: TimeInterval = 0
        var entries = [BarChartDataEntry]()
        var cravingDict = [Date: Int]()
        var smokedDict = [Date: Int]()
        
        guard cravingData.count > 0 else {
            return
        }
        
        cravingData.forEach {
            let date = standardisedDate(date: $0.cravingDate ?? Date())
            if $0.cravingSmoked {
                smokedDict[date] = smokedDict[date] == nil ? 1 :
                    smokedDict[date]! + 1
            } else {
                cravingDict[date] = cravingDict[date] == nil ? 1 : cravingDict[date]! + 1
            }
        }
        if let minTimeInterval = (cravingDict.map { $0.key.timeIntervalSince1970 }).min() {
            referenceTimeInterval = minTimeInterval
        }
        barChart.xAxis.valueFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval,
                                                         dateFormatter: mediumDateFormatter())
        cravingDict.forEach {
            let timeInerval = $0.key.timeIntervalSince1970
            let xValue = (timeInerval - referenceTimeInterval) / (3600 * 24)
            let cravingCount = $0.value
            let smokedCount = smokedDict[$0.key]
            let entry = BarChartDataEntry(x: xValue, yValues: [Double(cravingCount), Double(smokedCount ?? 0)])
            entries.append(entry)
        }
        entries.sort(by: {$0.x < $1.x})
        let barChartSet = BarChartDataSet(values: entries, label: "")
        barChartSet.colors = [UIColor.white, UIColor.lightGray]
        barChartSet.stackLabels = ["Cravings", "Smoked"]
        barChartSet.drawValuesEnabled = false
        let data = BarChartData(dataSets: [barChartSet])
        barChart.data = data
        barChart.notifyDataSetChanged()
    }
    
    func formatBarChart() {
        let xAxis = barChart?.xAxis
        let leftAxis = barChart?.leftAxis
        let rightAxis = barChart?.rightAxis
        //No data formatting
        barChart.noDataText = "No cravings!"
        barChart.noDataFont = UIFont(name: "AvenirNext-Bold", size: 20)
        barChart.noDataTextColor = .white
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
        leftAxis?.setLabelCount(2, force: false)
        leftAxis?.drawGridLinesEnabled = false
        rightAxis?.drawAxisLineEnabled = false
        leftAxis?.drawAxisLineEnabled = false
        rightAxis?.drawLabelsEnabled = false
        leftAxis?.labelTextColor = .white
        rightAxis?.drawGridLinesEnabled = false
        barChart.backgroundColor = .clear
        barChart.legend.textColor = .white
        barChart.legend.font = UIFont(name: "AvenirNext-Bold", size: 15)!
        barChart.chartDescription?.text = ""
        barChart.highlightPerTapEnabled = false
        leftAxis?.labelFont = UIFont(name: "AvenirNext-Bold", size: 15)!
        barChart.isUserInteractionEnabled = false
        barChart.frame = frame
    }
    
    func standardisedDate(date: Date) -> Date {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        let stringDate = formatter.string(from: date)
        return formatter.date(from: stringDate)!
    }
    
    func mediumDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}
