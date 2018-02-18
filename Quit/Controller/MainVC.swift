//
//  MainVC.swift
//  Quit
//
//  Created by Alex Tudge on 02/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import Charts
import StoreKit
import UIKit
import UserNotifications

class MainVC: UITableViewController, QuitVCDelegate, savingGoalVCDelegate, settingsVCDelegate {
    
    let refreshController = UIRefreshControl()
    let userDefaults = UserDefaults.standard
    var persistenceManager: PersistenceManager? = nil
    var quitData: QuitData? = nil
    var hasSetupOnce = false
    
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
        self.tableView.refreshControl = refreshController
        refreshController.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshController.tintColor = UIColor(red: 102/255, green: 204/255, blue: 150/255, alpha: 1)
        //Assume no quit date is set
        setQuitDataButton.isHidden = false
        quitDateLabel.isHidden = true
        cravingButton.isHidden = true
        addSavingButton.isHidden = true
        savingsPageControl.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !hasSetupOnce {
            //This needs to be called only once, but also after the UI has been setup to ensure object dimensions are correct
            setupUI()
        }
    }
    
    @objc private func refreshData(_ sender: Any) {
        isQuitDateSet()
    }
    
    func setupUI() {
        tableView.rowHeight = UIScreen.main.bounds.height / 2
        //Request permission to send notifications
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in }
        isQuitDateSet()
    }
    
    func isQuitDateSet() {
        if let returnedData = userDefaults.object(forKey: "quitData") as? [String: Any] {
            quitData = QuitData(smokedDaily: returnedData["smokedDaily"] as! Int, costOf20: returnedData["costOf20"] as! Double, quitDate: returnedData["quitDate"] as! Date)
            //If a quit date has been set, populate the UI
            section2Placeholder.isHidden = true
            section3Placeholder.isHidden = true
            section4Placeholder.isHidden = true
            setupSection1()
            setupSection2()
            setupSection3()
            //Only set up health stats if the quit date has passed
            if (quitData?.quitDate)! < Date() {
                setupSection4()
            } else {
                let subViews = self.healthScrollView.subviews
                for subview in subViews {
                    subview.removeFromSuperview()
                }
            }
            appStoreReview()
        }
        refreshController.endRefreshing()
    }
    
    func appStoreReview() {
        //Ask for a store review after a few days of quitting
        if Date().timeIntervalSince(quitData!.quitDate) > 518400 {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQuitInfoVC" {
            if let destination = segue.destination as? QuitInfoVC {
                destination.delegate = self
                destination.quitData = self.quitData
            }
        }
        if segue.identifier == "toSettingsVC" {
            if let destination = segue.destination as? SettingsVC {
                destination.delegate = self
                destination.persistenceManager = self.persistenceManager
            }
        }
        if segue.identifier == "toSavingGoalVC" {
            if let destination = segue.destination as? SavingGoalVC {
                destination.delegate = self
                destination.persistenceManager = self.persistenceManager
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
        if quitData?.quitDate != nil {
            setQuitDataButton.isHidden = true
            quitDateLabel.isHidden = false
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            quitDateLabel.text = "\(formatter.string(from: quitData!.quitDate))"
        }
    }
    
    //Establish a timer to show length smoke free
    func setupQuitTimer() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountdownLabel), userInfo: nil, repeats: true)
    }
    
    @objc func updateCountdownLabel() {
        countdownLabel.text = "\(Date().offsetFrom(date: quitData!.quitDate))"
    }
    
    @IBAction func cravingButton(_ sender: Any) {
        let alertController = UIAlertController(title: "Did you smoke?", message: "If you smoked, be honest. We'll reset your counter but that doesn't mean the time you've been clean for means nothing.\n\n Bin anything you've got left and carry on!.\n\n Add a catagory or trigger below if you want to track them. Craving data will appear after 24 hours.", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { action in
            //Reset the quit date if they've smoked
            if (self.quitData?.quitDate)! < Date() {
                let quitData: [String: Any] = ["smokedDaily": self.quitData!.smokedDaily, "costOf20": self.quitData!.costOf20, "quitDate": Date()]
                self.userDefaults.set(quitData, forKey: "quitData")
                self.isQuitDateSet()
            }
            let textField = alertController.textFields![0] as UITextField
            //Add the craving data to coreData
            self.persistenceManager?.addCraving(catagory: (textField.text != nil) ? textField.text!.capitalized : "", smoked: true)
        }
        alertController.addAction(yesAction)
        let noAction = UIAlertAction(title: "No", style: .default) { action in
            let textField = alertController.textFields![0] as UITextField
            self.persistenceManager?.addCraving(catagory: (textField.text != nil) ? textField.text! : "", smoked: false)
            self.isQuitDateSet()
        }
        alertController.addAction(noAction)
        alertController.addTextField { (textField) in
            textField.placeholder = "Store a mood or trigger?"
        }
        self.present(alertController, animated: true) { }
    }
}

//Section 2 - Financial Info
extension MainVC {
    func setupSection2() {
        savingsPageControl.isHidden = false
        let subViews = self.savingsScrollView.subviews
        for subview in subViews {
            subview.removeFromSuperview()
        }
        fetchSavingsGoalsData()
        populateScrollView()
    }
    
    func fetchSavingsGoalsData() {
        let savingsData = persistenceManager?.savingsGoals
        if let count = savingsData?.count {
            self.savingsPageControl.numberOfPages = count + 1
        } else {
            self.savingsPageControl.numberOfPages = 1
        }
    }
    
    func populateScrollView()  {
        let scrollViewWidth = self.savingsScrollView.bounds.width
        let scrollViewHeight = self.savingsScrollView.bounds.height
        let savingsInfoAtt = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.backgroundColor: UIColor.black, NSAttributedStringKey.font: UIFont(name: "AvenirNext-Bold", size: 30)!]
        //Setting up the savings overview screen
        var screenOneText = NSAttributedString()
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let formattedDailyCost = formatter.string(from: quitData!.costPerDay as NSNumber), let formattedAnnualCost = formatter.string(from: quitData!.costPerYear as NSNumber), let formattedSoFarSaving = formatter.string(from: quitData!.savedSoFar as NSNumber) {
            if (quitData?.quitDate)! < Date() {
                screenOneText = NSAttributedString(string: "\(formattedDailyCost) saved daily, \(formattedAnnualCost) saved yearly. \(formattedSoFarSaving) saved so far.", attributes: savingsInfoAtt)
            } else {
                screenOneText = NSAttributedString(string: "You're going to save \(formattedDailyCost) daily and \(formattedAnnualCost) yearly.", attributes: savingsInfoAtt)
            }
        }
        let savingsPageOne = UITextView(frame: CGRect(x:0, y: scrollViewHeight / 3, width: scrollViewWidth, height: scrollViewHeight))
        savingsPageOne.attributedText = screenOneText
        savingsPageOne.backgroundColor = .clear
        savingsPageOne.isEditable = false
        self.savingsScrollView.addSubview(savingsPageOne)
        //Set up any potential savings goals
        for x in 0..<persistenceManager!.savingsGoals.count {
            let progress = KDCircularProgress(frame: CGRect(x: scrollViewWidth * CGFloat(x + 1), y: 0 ,width: scrollViewWidth, height: scrollViewHeight))
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            tap.numberOfTapsRequired = 1
            progress.tag = x
            progress.isUserInteractionEnabled = true
            progress.addGestureRecognizer(tap)
            progress.startAngle = -90
            progress.progressThickness = 0.6
            progress.trackThickness = 0.6
            progress.clockwise = true
            progress.gradientRotateSpeed = 2
            progress.roundedCorners = false
            progress.glowMode = .forward
            progress.trackColor = .lightGray
            progress.glowAmount = 0.5
            progress.set(colors: UIColor(red: 102/255, green: 204/255, blue: 150/255, alpha: 1))
            var progressAngle = 0.0
            if (quitData?.quitDate)! < Date() {
                progressAngle = (quitData!.savedSoFar / (persistenceManager?.savingsGoals[x].goalAmount)!) * 360
            }
            progress.animate(toAngle: progressAngle < 360 ? progressAngle : 360, duration: 2, completion: nil)
            self.savingsScrollView.addSubview(progress)
            let label = UILabel(frame: CGRect(x: (scrollViewWidth * CGFloat(x + 1) + (scrollViewWidth / 3)), y: scrollViewHeight / 2 ,width: scrollViewWidth - (scrollViewWidth / 3), height: 100))
            let string = NSAttributedString(string: persistenceManager!.savingsGoals[x].goalName!, attributes: savingsInfoAtt)
            label.attributedText = string
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.minimumScaleFactor = 0.5
            self.savingsScrollView.addSubview(label)
        }
        self.savingsScrollView.contentSize = CGSize(width:self.savingsScrollView.frame.width * CGFloat(1 + (persistenceManager?.savingsGoals.count ?? 0)), height:self.savingsScrollView.frame.height)
        self.savingsScrollView.delegate = self
        self.savingsPageControl.currentPage = 0
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let view = sender.view
        let tag = view?.tag
        let savingGoal = persistenceManager?.savingsGoals[tag!]
        performSegue(withIdentifier: "toSavingGoalVC", sender: savingGoal)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        let pageWidth = savingsScrollView.frame.width
        let currentPage = floor((savingsScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        self.savingsPageControl.currentPage = Int(currentPage)
    }
}

//Section 3 - Craving information
extension MainVC {
    func setupSection3() {
        fetchCravingData()
        addSavingButton.isHidden = false
    }
    
    func fetchCravingData() {
        let subViews = self.cravingScrollView.subviews
        for subview in subViews {
            subview.removeFromSuperview()
        }
        var cravingTriggerDictionary = [String: Int]()
        var cravingDateDictionary = [Date: Int]()
        var smokedDateDictionary = [Date: Int]()
        let cravingData = persistenceManager?.cravings
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short
        for x in cravingData! {
            if let catagory = x.cravingCatagory {
                cravingTriggerDictionary[catagory] = (cravingTriggerDictionary[catagory] == nil) ? 1 : cravingTriggerDictionary[catagory]! + 1
            }
            if let y = x.cravingDate {
                let stringDate = dateFormatter.string(from: y)
                let standardisedDate = dateFormatter.date(from: stringDate)
                cravingDateDictionary[standardisedDate!] = (cravingDateDictionary[standardisedDate!] == nil) ? 1 : cravingDateDictionary[standardisedDate!]! + 1
                if x.cravingSmoked == true {
                    smokedDateDictionary[standardisedDate!] = (smokedDateDictionary[standardisedDate!] == nil) ? 1 : smokedDateDictionary[standardisedDate!]! + 1
                }
            }
        }
        displayCravingsData(cravingDict: cravingDateDictionary, smokedDict: smokedDateDictionary, catagoryDict: cravingTriggerDictionary)
    }
    
    func displayCravingsData(cravingDict: [Date: Int], smokedDict: [Date: Int], catagoryDict: [String: Int]) {
        let scrollViewHeight = cravingScrollView.bounds.height
        let scrollViewWidth = cravingScrollView.bounds.width
        //Setup chart
        let recentCravingsLineChart = CombinedChartView(frame: CGRect(x: 0, y: 0, width: scrollViewWidth, height: scrollViewHeight))
        recentCravingsLineChart.noDataText = "Data on you cravings and smoking habits will be displayed here!"
        recentCravingsLineChart.noDataFont = UIFont(name: "AvenirNext-Bold", size: 20)
        recentCravingsLineChart.noDataTextColor = .white
        recentCravingsLineChart.noDataTextAlignment = .center
        cravingScrollView.addSubview(recentCravingsLineChart)
        var referenceTimeInterval: TimeInterval = 0
        if let minTimeInterval = (cravingDict.map { $0.key.timeIntervalSince1970 }).min() {
            referenceTimeInterval = minTimeInterval
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let xValuesNumberFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: formatter)
        let xAxis = recentCravingsLineChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelCount = cravingDict.count
        xAxis.drawLabelsEnabled = true
        xAxis.drawLimitLinesBehindDataEnabled = true
        xAxis.avoidFirstLastClippingEnabled = true
        xAxis.valueFormatter = xValuesNumberFormatter
        var entries = [ChartDataEntry]()
        var smokedEntries = [BarChartDataEntry]()
        for x in cravingDict {
            let timeInerval = x.key.timeIntervalSince1970
            let xValue = (timeInerval - referenceTimeInterval) / (3600 * 24)
            let yValue = x.value
            let smokedYValue = smokedDict[x.key]
            let entry = ChartDataEntry(x: xValue, y: Double(yValue))
            let smokedEntry = BarChartDataEntry(x: xValue, y: smokedYValue == nil ? 0 : Double(smokedYValue!))
            entries.append(entry)
            smokedEntries.append(smokedEntry)
        }
        entries.sort(by: {$0.x < $1.x})
        smokedEntries.sort(by: {$0.x < $1.x})
        let line1 = LineChartDataSet(values: entries, label: "Cravings")
        let barChartSet = BarChartDataSet(values: smokedEntries, label: "Smoked")
        line1.colors = [UIColor.white]
        line1.mode = .linear
        line1.drawCirclesEnabled = false
        line1.drawValuesEnabled = false
        line1.lineWidth = 5
        barChartSet.colors = [UIColor.red]
        barChartSet.drawValuesEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.labelTextColor = .white
        xAxis.setLabelCount(2, force: true)
        xAxis.avoidFirstLastClippingEnabled = true
        xAxis.labelFont = UIFont(name: "AvenirNext-Bold", size: 15)!
        xAxis.axisLineColor = .white
        xAxis.axisLineWidth = 2.5
        recentCravingsLineChart.leftAxis.drawGridLinesEnabled = false
        recentCravingsLineChart.rightAxis.drawAxisLineEnabled = false
        recentCravingsLineChart.leftAxis.drawAxisLineEnabled = false
        recentCravingsLineChart.rightAxis.drawLabelsEnabled = false
        recentCravingsLineChart.leftAxis.labelTextColor = .white
        recentCravingsLineChart.rightAxis.drawGridLinesEnabled = false
        recentCravingsLineChart.backgroundColor = .clear
        //recentCravingsLineChart.legend.enabled = false
        recentCravingsLineChart.legend.textColor = .white
        recentCravingsLineChart.legend.font = UIFont(name: "AvenirNext-Bold", size: 15)!
        recentCravingsLineChart.chartDescription?.text = ""
        recentCravingsLineChart.highlightPerTapEnabled = false
        recentCravingsLineChart.leftAxis.labelFont = UIFont(name: "AvenirNext-Bold", size: 15)!
        recentCravingsLineChart.isUserInteractionEnabled = false
        let data = CombinedChartData()
        data.lineData = LineChartData(dataSets: [line1])
        data.barData = BarChartData(dataSets: [barChartSet])
        recentCravingsLineChart.data = data
        let sortedDict = catagoryDict.sorted(by: { $0.value > $1.value })
        let textField = UITextView(frame: CGRect(x: scrollViewWidth * 1, y: 0, width: scrollViewWidth - 10, height: scrollViewHeight))
        textField.backgroundColor = .clear
        textField.isEditable = false
        var string = ""
        for x in sortedDict {
            guard x.key != "" else { continue }
            string += "\(x.key): \(x.value)\n"
        }
        let attString = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "AvenirNext-Bold", size: 30)!]
        textField.attributedText = NSAttributedString(string: string, attributes: attString)
        cravingScrollView.addSubview(textField)
        self.cravingScrollView.contentSize = CGSize(width: scrollViewWidth * 2, height: scrollViewHeight)
        self.cravingScrollView.bounces = false
        self.cravingScrollView.delegate = self
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
            if (quitData!.minuteSmokeFree / x) * 100 < 100 {
                attString = NSAttributedString(string: "\(i): \(Int((quitData!.minuteSmokeFree / x) * 100 < 100 ? (quitData!.minuteSmokeFree / x) * 100 : 100))%", attributes: notAchieved)
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
