//
//  SectionThreeTriggerChartCell.swift
//  Quit
//
//  Created by Alex Tudge on 09/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit
import Charts

class SectionThreeTriggerChartCell: UICollectionViewCell {
    
    @IBOutlet weak var roundedView: RoundedView!
    @IBOutlet weak var lineChartView: LineChartView!
    
    private var gradientLayer: CAGradientLayer?
    var persistenceManager: PersistenceManager? {
        didSet {
            loadChartData()
        }
    }
    
    private struct CategoryData {
        var category: String?
        var dict = [Date: Int]()
        init(category: String? = nil) {
            self.category = category
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
        formatChart()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = roundedView.bounds
        gradientLayer?.cornerRadius = roundedView.layer.cornerRadius
    }
    
    func formatChart() {
        let xAxis = lineChartView?.xAxis
        let leftAxis = lineChartView?.leftAxis
        let rightAxis = lineChartView?.rightAxis
        //No data formatting
        lineChartView.noDataText = "Your craving triggers will appear here"
        lineChartView.noDataFont = UIFont(name: "AvenirNext-Bold", size: 20)
        lineChartView.noDataTextColor = .white
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
        lineChartView.backgroundColor = .clear
        lineChartView.legend.textColor = .white
        lineChartView.legend.font = UIFont(name: "AvenirNext-Bold", size: 15)!
        lineChartView.chartDescription?.text = ""
        lineChartView.highlightPerTapEnabled = false
        leftAxis?.labelFont = UIFont(name: "AvenirNext-Bold", size: 15)!
        lineChartView.isUserInteractionEnabled = true
        lineChartView.frame = frame
    }
    
    func loadChartData() {
        guard let cravingData = persistenceManager?.cravings else {
            return
        }
        var categories = [String]()
        var referenceTimeInterval: TimeInterval = 0
        var categoryDataArray = [CategoryData]()
        
        cravingData.forEach {
            if let category = $0.cravingCatagory,
                category != "",
                !categories.contains(category) {
                categories.append(category)
            }
        }
        
        guard categories.count > 0 else {
            return
        }
        
        categories.forEach {
            var categoryDict = CategoryData()
            categoryDict.category = $0
            cravingData.forEach {
                let date = standardisedDate(date: $0.cravingDate ?? Date())
                guard let category = $0.cravingCatagory,
                    category == categoryDict.category else {
                        return
                }
                categoryDict.dict[date] = categoryDict.dict[date] == nil ? 1 :
                    categoryDict.dict[date]! + 1
            }
            categoryDataArray.append(categoryDict)
        }
        
        var minTimeInterval: TimeInterval = 0
        categoryDataArray.forEach {
            let localMinTimeInterval: TimeInterval = 0
            if let localMinTimeInterval = ($0.dict.map { $0.key.timeIntervalSince1970 }).min() {
                if localMinTimeInterval < minTimeInterval {
                    minTimeInterval = localMinTimeInterval
                }
            }
        }
        referenceTimeInterval = minTimeInterval
        
        lineChartView.xAxis.valueFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: mediumDateFormatter())
        
        let data = LineChartData()
        categoryDataArray.forEach {
            let dict = $0.dict
            var entries = [ChartDataEntry]()
            dict.forEach {
                let timeInerval = $0.key.timeIntervalSince1970
                let xValue = (timeInerval - referenceTimeInterval) / (3600 * 24)
                let categoryCount = $0.value
                let entry = ChartDataEntry(x: xValue, y: Double(categoryCount))
                entries.append(entry)
            }
            entries.sort(by: {$0.x < $1.x})
            let chartSet = LineChartDataSet(values: entries, label: $0.category)
            chartSet.drawValuesEnabled = false
            chartSet.drawCirclesEnabled = false
            chartSet.setColor(randomColor(), alpha: 1)
            data.addDataSet(chartSet)
        }
        lineChartView.data = data
    }
    
    private func randomColor() -> UIColor {
        let randomRed: CGFloat = CGFloat(drand48())
        let randomGreen: CGFloat = CGFloat(drand48())
        let randomBlue: CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}
