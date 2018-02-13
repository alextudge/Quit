//
//  MainVC.swift
//  Quit
//
//  Created by Alex Tudge on 02/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import Charts
import CoreData
import StoreKit
import UIKit
import UserNotifications


let healthStats: [String: Double] = ["Correcting blood pressure": 20, "Normalising heart rate": 20, "Nicotine down to 90%": 480, "Raising blood oxygen levels to normal": 480, "Normalising carbon monoxide levels": 720, "Started removing lung debris": 1440, "Starting to repair nerve endings": 2880, "Correcting smell and taste": 2880, "Removing all nicotine": 4320, "Improving lung performance": 4320, "Worst withdrawal symptoms over": 4320, "Fixing mouth and gum circulation": 14400, "Emotional trauma ended": 21600, "Halving heart attack risk": 525600]

//Create a feed of user posts about their quit experience
//SavingsGoals dont reset after quit date is set to future.

class MainVC: UITableViewController, NSFetchedResultsControllerDelegate, QuitVCDelegate, savingGoalVCDelegate, settingsVCDelegate {
    
    var cravingController: NSFetchedResultsController<Craving>!
    var savingsController: NSFetchedResultsController<SavingGoal>!
    let userDefaults = UserDefaults.standard
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
    
    override func viewDidAppear(_ animated: Bool) {
        if !hasSetupOnce {
            //This needs to be called only once, but also after the UI has been setup to ensure object dimensions are correct
            setupUI()
        }
    }
    
    func generateTestDate() {
        //Generate data for the appStore video
    }
    
    func setupUI() {
        tableView.rowHeight = UIScreen.main.bounds.height / 2
        //Assume no quit date is set
        setQuitDataButton.isHidden = false
        quitDateLabel.isHidden = true
        cravingButton.isHidden = true
        isQuitDateSet()
        //Request permission to send notifications
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in }
    }
    
    func isQuitDateSet() {
        if let returnedData = userDefaults.object(forKey: "quitData") as? [String: Any] {
            quitData = QuitData(smokedDaily: returnedData["smokedDaily"] as! Int, costOf20: returnedData["costOf20"] as! Double, quitDate: returnedData["quitDate"] as! Date)
            //If a quit date has been set, populate the UI
            appStoreReview()
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
        }
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
            }
        }
        if segue.identifier == "toSavingGoalVC" {
            if let destination = segue.destination as? SavingGoalVC {
                destination.delegate = self
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
        let alertController = UIAlertController(title: "Did you smoke?", message: "If you smoked, be honest. We'll reset your counter but that doesn't mean the time you've been clean for means nothing.\n\n It's your health, not a game - bin anything you've got left and pick yourself back up.\n\n Add a catagory or trigger below if you want to track them!", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { action in
            //Reset the quit date if they've smoked
            if (self.quitData?.quitDate)! < Date() {
                let quitData: [String: Any] = ["smokedDaily": self.quitData!.smokedDaily, "costOf20": self.quitData!.costOf20, "quitDate": Date()]
                self.userDefaults.set(quitData, forKey: "quitData")
                self.isQuitDateSet()
            }
            let textField = alertController.textFields![0] as UITextField
            //Add the craving data to coreData
            self.addCraving(catagory: (textField.text != nil) ? textField.text!.capitalized : "", smoked: true)
        }
        alertController.addAction(yesAction)
        let noAction = UIAlertAction(title: "No", style: .default) { action in
            let textField = alertController.textFields![0] as UITextField
            self.addCraving(catagory: (textField.text != nil) ? textField.text! : "", smoked: false)
        }
        alertController.addAction(noAction)
        alertController.addTextField { (textField) in
            textField.placeholder = "Store a mood or trigger?"
        }
        self.present(alertController, animated: true) { }
    }
    
    func addCraving(catagory: String, smoked: Bool) {
        let craving = Craving(context: context)
        craving.cravingCatagory = catagory
        craving.cravingDate = Date()
        craving.cravingSmoked = smoked
        ad.saveContext()
        fetchCravingData()
    }
}

//Section 2 - Financial Info
extension MainVC {
    func setupSection2() {
        let subViews = self.savingsScrollView.subviews
        for subview in subViews {
            subview.removeFromSuperview()
        }
        fetchSavingsGoalsData()
        populateScrollView()
    }
    
    func fetchSavingsGoalsData() {
        let fetchRequest: NSFetchRequest<SavingGoal> = SavingGoal.fetchRequest()
        let sort = NSSortDescriptor(key: "goalAmount", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        self.savingsController = controller
        do {
            try self.savingsController.performFetch()
            if let count = self.savingsController.fetchedObjects?.count {
                self.savingsPageControl.numberOfPages = count + 1
            } else {
                self.savingsPageControl.numberOfPages = 1
            }
        } catch {
            let error = error as NSError
            print("\(error)")
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
        for x in 0..<savingsController.fetchedObjects!.count {
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
            let progressAngle = (quitData!.savedSoFar / savingsController.fetchedObjects![x].goalAmount) * 360
            progress.animate(toAngle: progressAngle < 360 ? progressAngle : 360, duration: 2, completion: nil)
            self.savingsScrollView.addSubview(progress)
            let label = UILabel(frame: CGRect(x: (scrollViewWidth * CGFloat(x + 1) + (scrollViewWidth / 3)), y: scrollViewHeight / 2 ,width: scrollViewWidth - (scrollViewWidth / 3), height: 100))
            let string = NSAttributedString(string: savingsController.fetchedObjects![x].goalName!, attributes: savingsInfoAtt)
            label.attributedText = string
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.minimumScaleFactor = 0.5
            self.savingsScrollView.addSubview(label)
        }
        self.savingsScrollView.contentSize = CGSize(width:self.savingsScrollView.frame.width * CGFloat(1 + (savingsController.fetchedObjects?.count ?? 0)), height:self.savingsScrollView.frame.height)
        self.savingsScrollView.delegate = self
        self.savingsPageControl.currentPage = 0
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let view = sender.view
        let tag = view?.tag
        let savingGoal = savingsController.fetchedObjects![tag!]
        performSegue(withIdentifier: "toSavingGoalVC", sender: savingGoal)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        let pageWidth = savingsScrollView.frame.width
        let currentPage = floor((savingsScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        self.savingsPageControl.currentPage = Int(currentPage)
    }
    
    func addSavingGoal(title: String, cost: Double) {
        let saving = SavingGoal(context: context)
        saving.goalName = title
        saving.goalAmount = cost
        ad.saveContext()
    }
}

//Section 3 - Craving information
extension MainVC {
    func setupSection3() {
        fetchCravingData()
    }
    
    func fetchCravingData() {
        let subViews = self.cravingScrollView.subviews
        for subview in subViews {
            subview.removeFromSuperview()
        }
        var cravingTriggerDictionary = [String: Int]()
        var cravingDateDictionary = [Date: Int]()
        var smokedDateDictionary = [Date: Int]()
        //Fetching data on cravings.
        let fetchRequest: NSFetchRequest<Craving> = Craving.fetchRequest()
        let dateSort = NSSortDescriptor(key: "cravingDate", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        self.cravingController = controller
        do {
            try self.cravingController.performFetch()
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .short
            for x in self.cravingController.fetchedObjects! {
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
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    func displayCravingsData(cravingDict: [Date: Int], smokedDict: [Date: Int], catagoryDict: [String: Int]) {
        let scrollViewHeight = cravingScrollView.bounds.height
        let scrollViewWidth = cravingScrollView.bounds.width
        //Setup chart
        let recentCravingsLineChart = CombinedChartView(frame: CGRect(x: 0, y: 0, width: scrollViewWidth, height: scrollViewHeight))
        recentCravingsLineChart.noDataText = "Data on you cravings and smoking habits will be diaplayed here!"
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
        barChartSet.colors = [UIColor.white]
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
        recentCravingsLineChart.legend.enabled = false
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
        for (i,x) in healthStats {
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
        self.healthScrollView.contentSize = CGSize(width: scrollViewWidth, height: CGFloat(healthStats.count * 100))
        self.healthScrollView.delegate = self
    }
}
