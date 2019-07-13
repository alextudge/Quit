//
//  SectionThreeCravingsChartCell.swift
//  Quit
//
//  Created by Alex Tudge on 06/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import Charts

protocol SectionThreeCravingsChartCellDelegate: class {
    func didTapCravingsDetailButton()
}

class SectionThreeCravingsChartCell: UICollectionViewCell {
    
    @IBOutlet weak var roundedView: RoundedView!
    @IBOutlet weak var barChart: LineChartView!
    
    weak var delegate: SectionThreeCravingsChartCellDelegate?
    
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
        formatBarChart()
    }
    
    func reloadBarChart() {
        barChart.notifyDataSetChanged()
        barChart.data?.notifyDataChanged()
    }
    
    private func loadBarChartData() {
        guard let cravingData = persistenceManager?.cravings,
            cravingData.count > 0 else {
            return
        }
        var referenceTimeInterval: TimeInterval = 0
        var cravingEntries = [ChartDataEntry]()
        var smokedEntries = [ChartDataEntry]()
        var cravingDict = [Date: Int]()
        var smokedDict = [Date: Int]()
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
        barChart.xAxis.valueFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: mediumDateFormatter())
        cravingDict.forEach {
            let timeInerval = $0.key.timeIntervalSince1970
            let xValue = (timeInerval - referenceTimeInterval) / (3600 * 24)
            let cravingCount = $0.value
            let entry = ChartDataEntry(x: xValue, y: Double(cravingCount))
            cravingEntries.append(entry)
            if let smokedCount = smokedDict[$0.key] {
                let smokedEntry = ChartDataEntry(x: xValue, y: Double(smokedCount))
                smokedEntries.append(smokedEntry)
            }
        }
        cravingEntries.sort(by: {$0.x < $1.x})
        smokedEntries.sort(by: {$0.x < $1.x})
        let cravingLine = LineChartDataSet(entries: cravingEntries, label: "Cravings")
        let smokedLine = LineChartDataSet(entries: smokedEntries, label: "Smoked")
        cravingLine.colors = [Styles.Colours.blueColor]
        cravingLine.drawCirclesEnabled = false
        cravingLine.drawValuesEnabled = false
        let gradientColors = [Styles.Colours.blueColor.cgColor, UIColor.clear.cgColor] as CFArray
        let colorLocations: [CGFloat] = [1.0, 0.0]
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
        cravingLine.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
        cravingLine.drawFilledEnabled = true
        smokedLine.colors = [Styles.Colours.greenColour]
        smokedLine.drawCirclesEnabled = false
        smokedLine.drawValuesEnabled = false
        let smokedGradientColors = [Styles.Colours.greenColour.cgColor, UIColor.clear.cgColor] as CFArray
        let smokedColorLocations: [CGFloat] = [1.0, 0.0]
        let smokedGradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: smokedGradientColors, locations: smokedColorLocations)
        smokedLine.fill = Fill.fillWithLinearGradient(smokedGradient!, angle: 90.0)
        smokedLine.drawFilledEnabled = true
        let data = LineChartData()
        data.addDataSet(smokedLine)
        data.addDataSet(cravingLine)
        barChart.data = data
        barChart.pinchZoomEnabled = true
        barChart.doubleTapToZoomEnabled = true
        barChart.dragEnabled = false
        barChart.notifyDataSetChanged()
    }
    
    func formatBarChart() {
        let xAxis = barChart?.xAxis
        let leftAxis = barChart?.leftAxis
        let rightAxis = barChart?.rightAxis
        //No data formatting
        barChart.noDataText = "Recorded cravings will appear here"
        barChart.noDataFont = UIFont(name: "AvenirNext-Bold", size: 20)!
        barChart.noDataTextColor = .lightGray
        //Formatting the x (date) axis
        xAxis?.labelPosition = .bottom
        xAxis?.drawLabelsEnabled = true
        xAxis?.avoidFirstLastClippingEnabled = true
        xAxis?.drawGridLinesEnabled = false
        xAxis?.labelTextColor = .darkGray
        xAxis?.setLabelCount(2, force: true)
        xAxis?.avoidFirstLastClippingEnabled = true
        xAxis?.labelFont = UIFont(name: "AvenirNext-Bold", size: 15)!
        xAxis?.axisLineColor = .lightGray
        xAxis?.axisLineWidth = 2.5
        //Setup other UI elements
        leftAxis?.setLabelCount(2, force: false)
        leftAxis?.drawGridLinesEnabled = false
        rightAxis?.drawAxisLineEnabled = false
        leftAxis?.drawAxisLineEnabled = false
        rightAxis?.drawLabelsEnabled = false
        leftAxis?.labelTextColor = .darkGray
        rightAxis?.drawGridLinesEnabled = false
        barChart.legend.textColor = .darkGray
        barChart.legend.font = UIFont(name: "AvenirNext-Bold", size: 15)!
        barChart.chartDescription?.text = ""
        barChart.highlightPerTapEnabled = false
        leftAxis?.labelFont = UIFont(name: "AvenirNext-Bold", size: 15)!
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
    
    @IBAction private func didTapCravingsDetailButton(_ sender: Any) {
        delegate?.didTapCravingsDetailButton()
    }
}
