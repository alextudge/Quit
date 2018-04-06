//
//  MainVC.swift
//  Quit
//
//  Created by Alex Tudge on 02/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit
import Charts

class MainVC: UITableViewController, QuitVCDelegate, savingGoalVCDelegate, settingsVCDelegate {
    
    let refreshController = UIRefreshControl()
    
    lazy var barChart = generateBarChart()
    lazy var catagoryTextField = UITextView()
    
    var viewModel: MainVCViewModel!
    
    @IBOutlet weak var cravingButton: UIButton!
    @IBOutlet weak var quitDateLabel: UILabel!
    @IBOutlet weak var setQuitDataButton: UIButton!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var savingsScrollView: UIScrollView!
    @IBOutlet weak var savingsPageControl: UIPageControl!
    @IBOutlet weak var healthScrollView: UIScrollView!
    @IBOutlet weak var cravingScrollView: UIScrollView!
    @IBOutlet weak var section2Placeholder: UILabel!
    @IBOutlet weak var section3Placeholder: UILabel!
    @IBOutlet weak var section4Placeholder: UILabel!
    @IBOutlet weak var addSavingButton: UIButton!
    
    override func viewDidLoad() {
        
        viewModel = MainVCViewModel()
        
        viewModel.requestNotifAuth()
        setupInitialState()
        
        //Pull to refrsh the time-dependent data
        self.tableView.refreshControl = refreshController
        refreshController.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshController.tintColor = Constants.greenColour
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if !viewModel.hasSetupOnce {
            
            //This needs to be called only once, but also after the UI has been setup to ensure object dimensions are correct
            setupUI()
        }
    }
    
    func setupInitialState() {
        
        //Assume no quit date is set
        setQuitDataButton.isHidden = false
        quitDateLabel.isHidden = true
        cravingButton.isHidden = true
        addSavingButton.isHidden = true
        savingsPageControl.isHidden = true
    }
    
    func setupUI() {
        
        tableView.rowHeight = UIScreen.main.bounds.height / 2
        isQuitDateSet()
    }
    
    @objc private func refreshData(_ sender: Any) {
        isQuitDateSet()
    }
    
    func isQuitDateSet() {
        
        if viewModel.quitData != nil {
            
            //If a quit date has been set, populate the UI
            hidePlaceholders()
            setupSection1()
            setupSection2()
            setupSection3()
            
            //Only set up health stats if the quit date has passed
            if viewModel.quitDateIsInPast {
                setupSection4()
            } else {
                
                let subViews = self.healthScrollView.subviews
                for subview in subViews { subview.removeFromSuperview() }
            }
        }
        refreshController.endRefreshing()
    }
    
    func hidePlaceholders() {
        
        section2Placeholder.isHidden = true
        section3Placeholder.isHidden = true
        section4Placeholder.isHidden = true
    }
    
    //Pass relevent objects to new views
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQuitInfoVC" {
            if let destination = segue.destination as? QuitInfoVC {
                destination.delegate = self
                destination.quitData = viewModel.quitData
            }
        }
        if segue.identifier == "toSettingsVC" {
            if let destination = segue.destination as? SettingsVC {
                destination.delegate = self
                destination.persistenceManager = self.viewModel.persistenceManager
            }
        }
        if segue.identifier == "toSavingGoalVC" {
            if let destination = segue.destination as? SavingGoalVC {
                destination.delegate = self
                destination.persistenceManager = self.viewModel.persistenceManager
                if let sender = sender as? SavingGoal {
                    destination.savingGoal = sender
                }
            }
        }
    }
}

//SECTION 1 - countdown and craving entry
extension MainVC {
    
    func setupSection1() {
        
        cravingButton.isHidden = false
        displayQuitDate()
        setupQuitTimer()
    }
    
    func displayQuitDate() {
        
        if viewModel.quitData?.quitDate != nil {
            setQuitDataButton.isHidden = true
            quitDateLabel.isHidden = false
            quitDateLabel.text = viewModel.stringQuitDate()
        }
    }
    
    //Establish a timer to show length smoke free
    func setupQuitTimer() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountdownLabel), userInfo: nil, repeats: true)
    }
    
    @objc func updateCountdownLabel() {
        countdownLabel.text = viewModel.countdownLabel()
    }
    
    @IBAction func cravingButton(_ sender: Any) {
        let alertController = UIAlertController(title: viewModel.cravingButtonAlertTitle(), message: viewModel.cravingButtonAlertMessage(), preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { action in
            
            //Reset the quit date if they've smoked
            if self.viewModel.quitDateIsInPast {
                self.viewModel.setUserDefaultsQuitDateToCurrent()
            }
            
            let textField = alertController.textFields![0] as UITextField
            
            //Add the craving data to coreData
            self.viewModel.persistenceManager?.addCraving(catagory: (textField.text != nil) ? textField.text!.capitalized : "", smoked: true)
            self.isQuitDateSet()
            //Don't need to call processCravingData here as its covered by isQuitDateSet > setupSection3
        }
        
        alertController.addAction(yesAction)
        
        let noAction = UIAlertAction(title: "No", style: .default) { action in
            
            let textField = alertController.textFields![0] as UITextField
            self.viewModel.persistenceManager?.addCraving(catagory: (textField.text != nil) ? textField.text! : "", smoked: false)
            self.processCravingData()
            self.viewModel.appStoreReview()
        }
        
        alertController.addAction(noAction)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Store a mood or trigger?"
        }
        
        self.present(alertController, animated: true)
    }
}

//Section 2 - Financial Info
extension MainVC {
    
    func setupSection2() {
        
        savingsPageControl.isHidden = false
        let subViews = self.savingsScrollView.subviews
        for subview in subViews { subview.removeFromSuperview() }
        setSavingsPageControllerCount()
        populateScrollView()
    }
    
    func setSavingsPageControllerCount() {
        self.savingsPageControl.numberOfPages = viewModel.countForSavingPageController()
    }
    
    func populateScrollView()  {
        
        let scrollViewWidth = self.savingsScrollView.bounds.width
        let scrollViewHeight = self.savingsScrollView.bounds.height

        let savingsOverviewText = UITextView(frame: CGRect(x: 0, y: scrollViewHeight / 3, width: scrollViewWidth, height: scrollViewHeight))
        savingsOverviewText.attributedText = viewModel.savingsAttributedText()
        savingsOverviewText.backgroundColor = .clear
        savingsOverviewText.isEditable = false
        
        self.savingsScrollView.addSubview(savingsOverviewText)
        
        //Set up any potential savings goals
        for x in 0..<viewModel.persistenceManager.savingsGoals.count {
            
            let savingGoal = viewModel.persistenceManager!.savingsGoals[x]
            
            let savingGoalProgressView = viewModel.generateProgressView()
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapOnASavingsGoal(_:)))
            savingGoalProgressView.frame = CGRect(x: scrollViewWidth * CGFloat(x + 1), y: 0, width: scrollViewWidth, height: scrollViewHeight)
            tap.numberOfTapsRequired = 1
            savingGoalProgressView.tag = x
            savingGoalProgressView.addGestureRecognizer(tap)
            
            savingGoalProgressView.animate(toAngle: viewModel.savingsProgressAngle(goalAmount: savingGoal.goalAmount), duration: 2, completion: nil)
            
            self.savingsScrollView.addSubview(savingGoalProgressView)
            
            let label = UILabel(frame: CGRect(x: (scrollViewWidth * CGFloat(x + 1) + (scrollViewWidth / 3)), y: scrollViewHeight / 2 ,width: scrollViewWidth - (scrollViewWidth / 3), height: 100))
            let string = NSAttributedString(string: savingGoal.goalName!, attributes: Constants.savingsInfoAttributes)
            label.attributedText = string
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.minimumScaleFactor = 0.5
            
            self.savingsScrollView.addSubview(label)
        }
        
        self.savingsScrollView.contentSize = CGSize(width:self.savingsScrollView.frame.width * CGFloat(1 + (viewModel.persistenceManager?.savingsGoals.count ?? 0)), height: self.savingsScrollView.frame.height)
        self.savingsScrollView.delegate = self
        self.savingsPageControl.currentPage = 0
    }
    
    @objc func handleTapOnASavingsGoal(_ sender: UITapGestureRecognizer) {
        
        let view = sender.view
        let tag = view?.tag
        let savingGoal = viewModel.persistenceManager?.savingsGoals[tag!]
        performSegue(withIdentifier: "toSavingGoalVC", sender: savingGoal)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageWidth = savingsScrollView.frame.width
        let currentPage = floor((savingsScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        self.savingsPageControl.currentPage = Int(currentPage)
    }
}

//Section 3 - Craving information
extension MainVC {
    
    func setupSection3() {
        
        setupScrollView()
        processCravingData()
        addSavingButton.isHidden = false
    }
    
    func setupScrollView() {
        
        let scrollViewHeight = cravingScrollView.bounds.height
        let scrollViewWidth = cravingScrollView.bounds.width
        
        barChart.frame = CGRect(x: 0, y: 0, width: scrollViewWidth, height: scrollViewHeight)
        cravingScrollView.addSubview(barChart)
        catagoryTextField.frame = CGRect(x: scrollViewWidth * 1, y: 0, width: scrollViewWidth - 10, height: scrollViewHeight)
        catagoryTextField.backgroundColor = .clear
        catagoryTextField.isEditable = false
        cravingScrollView.addSubview(catagoryTextField)
        self.cravingScrollView.contentSize = CGSize(width: scrollViewWidth * 2, height: scrollViewHeight)
        self.cravingScrollView.bounces = false
        self.cravingScrollView.delegate = self
    }
    
    func generateBarChart() -> BarChartView {
        
        let barChart = BarChartView()
        let xAxis = barChart.xAxis
        let leftAxis = barChart.leftAxis
        let rightAxis = barChart.rightAxis
        //No data formatting
        barChart.noDataText = "Data on you cravings and smoking habits will be displayed here!"
        barChart.noDataFont = UIFont(name: "AvenirNext-Bold", size: 20)
        barChart.noDataTextColor = .white
        //Formatting the x (date) axis
        xAxis.labelPosition = .bottom
        xAxis.drawLabelsEnabled = true
        xAxis.drawLimitLinesBehindDataEnabled = true
        xAxis.avoidFirstLastClippingEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.labelTextColor = .white
        xAxis.setLabelCount(2, force: true)
        xAxis.avoidFirstLastClippingEnabled = true
        xAxis.labelFont = UIFont(name: "AvenirNext-Bold", size: 15)!
        xAxis.axisLineColor = .white
        xAxis.axisLineWidth = 2.5
        //Setup other UI elements
        leftAxis.setLabelCount(2, force: true)
        leftAxis.drawGridLinesEnabled = false
        rightAxis.drawAxisLineEnabled = false
        leftAxis.drawAxisLineEnabled = false
        rightAxis.drawLabelsEnabled = false
        leftAxis.labelTextColor = .white
        rightAxis.drawGridLinesEnabled = false
        barChart.backgroundColor = .clear
        barChart.legend.textColor = .white
        barChart.legend.font = UIFont(name: "AvenirNext-Bold", size: 15)!
        barChart.chartDescription?.text = ""
        barChart.highlightPerTapEnabled = false
        leftAxis.labelFont = UIFont(name: "AvenirNext-Bold", size: 15)!
        barChart.isUserInteractionEnabled = false
        return barChart
    }
    
//    func processCravingDataVM() -> ([Date: Int], [Date: Int], [String: Int]) {
//        
//        var cravingTriggerDictionary = [String: Int]()
//        var cravingDateDictionary = [Date: Int]()
//        var smokedDateDictionary = [Date: Int]()
//        
//        for craving in viewModel.persistenceManager.cravings {
//            if let cravingCatagory = craving.cravingCatagory {
//                cravingTriggerDictionary[cravingCatagory] = (cravingTriggerDictionary[cravingCatagory] == nil) ? 1 : cravingTriggerDictionary[cravingCatagory]! + 1
//            }
//            if let cravingDate = craving.cravingDate {
//                let standardisedDate = viewModel.standardisedDate(date: cravingDate)
//                if craving.cravingSmoked == true {
//                    smokedDateDictionary[standardisedDate] = (smokedDateDictionary[standardisedDate] == nil) ? 1 : smokedDateDictionary[standardisedDate]! + 1
//                } else {
//                    cravingDateDictionary[standardisedDate] = (cravingDateDictionary[standardisedDate] == nil) ? 1 : cravingDateDictionary[standardisedDate]! + 1
//                }
//            }
//        }
//        return (cravingDateDictionary, smokedDateDictionary, cravingTriggerDictionary)
//        //updateCravingData(cravingDict: cravingDateDictionary, smokedDict: smokedDateDictionary, catagoryDict: cravingTriggerDictionary)
//    }
    
    func processCravingData() {
        let data = viewModel.processCravingData()
        updateCravingData(cravingDict: data.0, smokedDict: data.1, catagoryDict: data.2)
    }
    
    func updateCravingData(cravingDict: [Date: Int], smokedDict: [Date: Int], catagoryDict: [String: Int]) {
        
        //Setup chart
        var referenceTimeInterval: TimeInterval = 0
        if let minTimeInterval = (cravingDict.map { $0.key.timeIntervalSince1970 }).min() {
            referenceTimeInterval = minTimeInterval
        }
        let xValuesNumberFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: viewModel.mediumDateFormatter())
        barChart.xAxis.valueFormatter = xValuesNumberFormatter
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
        barChart.data = data
        barChart.notifyDataSetChanged()
        let sortedDict = catagoryDict.sorted(by: { $0.value > $1.value })
        var string = ""
        for x in sortedDict {
            guard x.key != "" else { continue }
            string += "\(x.key): \(x.value)\n"
        }
        let attString = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "AvenirNext-Bold", size: 30)!]
        catagoryTextField.attributedText = NSAttributedString(string: string, attributes: attString)
    }
}

//Section 4 - Health
extension MainVC {
    func setupSection4() {
        prepareHealthScrollView()
    }
    
    func prepareHealthScrollView() {
        let subViews = self.healthScrollView.subviews
        for subview in subViews {
            subview.removeFromSuperview()
        }
        let achieved = [NSAttributedStringKey.foregroundColor: UIColor(red: 102/255, green: 204/255, blue: 150/255, alpha: 1), NSAttributedStringKey.font: UIFont(name: "AvenirNext-Bold", size: 30)!]
        let notAchieved = [NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.font: UIFont(name: "AvenirNext-Bold", size: 30)!]
        var int = 0
        let scrollViewWidth = self.healthScrollView.frame.width
        for (i,x) in Constants.healthStats {
            let label = UILabel(frame: CGRect(x: 0, y: int, width: Int(scrollViewWidth), height: 100))
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.minimumScaleFactor = 0.5
            let attString: NSAttributedString?
            if (viewModel.quitData!.minuteSmokeFree / x) * 100 < 100 {
                attString = NSAttributedString(string: "\(i): \(Int((viewModel.quitData!.minuteSmokeFree / x) * 100 < 100 ? (viewModel.quitData!.minuteSmokeFree / x) * 100 : 100))%", attributes: notAchieved)
            } else {
                attString = NSAttributedString(string: "\(i): 100%", attributes: achieved)
            }
            label.attributedText = attString
            self.healthScrollView.addSubview(label)
            int += Int(label.bounds.height)
        }
        self.healthScrollView.bounces = false
        self.healthScrollView.alwaysBounceHorizontal = false
        self.healthScrollView.contentSize = CGSize(width: scrollViewWidth, height: CGFloat(Constants.healthStats.count * 100))
        self.healthScrollView.delegate = self
    }
}
