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
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    var persistenceManager: PersistenceManager? {
        didSet {
            loadChartData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        formatChart()
    }
    
    func formatChart() {
        let xAxis = lineChartView?.xAxis
        let leftAxis = lineChartView?.leftAxis
        let rightAxis = lineChartView?.rightAxis
        //No data formatting
        lineChartView.noDataText = "No cravings!"
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
        guard let data = persistenceManager?.cravings else {
            return
        }
    }
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
