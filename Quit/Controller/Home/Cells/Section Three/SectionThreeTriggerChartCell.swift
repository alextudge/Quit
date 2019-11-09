//
//  SectionThreeTriggerChartCell.swift
//  Quit
//
//  Created by Alex Tudge on 09/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import Charts

class SectionThreeTriggerChartCell: UICollectionViewCell {
    
    @IBOutlet private weak var roundedView: RoundedView!
    @IBOutlet private weak var pieChartView: PieChartView!
    
    private var persistenceManager: PersistenceManager?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        formatChart()
    }
    
    func setup(persistenceManager: PersistenceManager?) {
        self.persistenceManager = persistenceManager
        loadChartData()
        pieChartView.animate(xAxisDuration: 0.25)
    }
}

private extension SectionThreeTriggerChartCell {
    func formatChart() {
        pieChartView.noDataText = "Your craving triggers will appear here"
        pieChartView.noDataFont = UIFont.systemFont(ofSize: 17, weight: .medium)
        pieChartView.noDataTextColor = .label
        pieChartView.transparentCircleRadiusPercent = 0
        pieChartView.drawSlicesUnderHoleEnabled = false
        pieChartView.legend.enabled = false
        pieChartView.holeColor = .clear
        pieChartView.backgroundColor = .clear
        pieChartView.chartDescription?.text = ""
        pieChartView.holeRadiusPercent = 0.2
        pieChartView.frame = frame
    }
    
    func loadChartData() {
        guard let cravingData = persistenceManager?.getCravings() else {
            return
        }
        let cravings: [String] = cravingData.compactMap {
            return $0.cravingCatagory
        }
        let countedCategories = Dictionary(grouping: cravings, by: { $0 })
        guard countedCategories.count > 0 else {
            return
        }
        
        let data = PieChartData()
        var entries = [ChartDataEntry]()
        var colours = [UIColor]()
        countedCategories.forEach {
            colours.append(randomColor())
            entries.append(PieChartDataEntry(value: Double($0.value.count), label: $0.key))
        }
        entries.sort(by: {$0.x < $1.x})
        let chartSet = PieChartDataSet(entries: entries, label: nil)
        chartSet.xValuePosition = .outsideSlice
        chartSet.valueLineColor = .clear
        chartSet.valueTextColor = .label
        chartSet.sliceSpace = 2
        chartSet.automaticallyDisableSliceSpacing = true
        chartSet.drawValuesEnabled = false
        chartSet.colors = colours
        data.addDataSet(chartSet)
        pieChartView.data = data
    }
    
    func randomColor() -> UIColor {
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 0.8)
    }
}
