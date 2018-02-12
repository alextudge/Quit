//
//  MainVC.swift
//  Quit
//
//  Created by Alex Tudge on 02/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import Charts
import CoreData
import UIKit
import UserNotifications

let healthStats: [String: Double] = ["Correcting blood pressure": 20, "Normalising heart rate": 20, "Nicotine down to 90%": 480, "Raising blood oxygen levels to normal": 720, "Returning carbon monoxide levels to normal": 720, "Starting to repair nerve endings": 2880, "Correcting smell and taste": 2880, "Removing all nicotine": 4320, "Improving lung performance": 4320, "Worst withdrawal symptoms over": 4320, "Fixing mouth and gum circulation": 14400, "Emotional trauma ended": 21600]

//Create a feed of user posts about their quit experience
//Make sure only if smoked == true does a bar appear
class MainVC: UITableViewController, NSFetchedResultsControllerDelegate, QuitVCDelegate, savingGoalVCDelegate {
    
    var cravingController: NSFetchedResultsController<Craving>!
    var savingsController: NSFetchedResultsController<SavingGoal>!
    let userDefaults = UserDefaults.standard
    var quitData: QuitData? = nil
    @IBOutlet weak var quitDateLabel: UILabel!
    @IBOutlet weak var setQuitInformationButton: UIButton!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var savingsScrollView: UIScrollView!
    @IBOutlet weak var savingsPageControl: UIPageControl!
    @IBOutlet weak var healthScrollView: UIScrollView!
    @IBOutlet weak var cravingScrollView: UIScrollView!
    
    //Set up the UI assuming no quit date has been set
    override func viewDidLoad() {
        tableView.rowHeight = UIScreen.main.bounds.height / 2
        setQuitInformationButton.isHidden = false
        quitDateLabel.isHidden = true
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in }
        isQuitDateSet()
    }
    
    //If a quit date has been set, populate the UI
    func isQuitDateSet() {
        if let returnedData = userDefaults.object(forKey: "quitData") as? [String: Any] {
            quitData = QuitData(smokedDaily: returnedData["smokedDaily"] as! Int, costOf20: returnedData["costOf20"] as! Double, quitDate: returnedData["quitDate"] as! Date)
            setupSection1()
            setupSection2()
            setupSection3()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQuitInfoVC" {
            if let destination = segue.destination as? QuitInfoVC {
                destination.delegate = self
                destination.quitData = self.quitData
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
        displayQuitDate()
    }
    
    func displayQuitDate() {
        if quitData != nil {
            print(quitData!)
            setQuitInformationButton.isHidden = true
            quitDateLabel.isHidden = false
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            quitDateLabel.text = "\(formatter.string(from: quitData!.quitDate))"
            setupQuitTimer()
        }
    }
    
    func setupQuitTimer() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountdownLabel), userInfo: nil, repeats: true)
    }
    
    @objc func updateCountdownLabel() {
        countdownLabel.text = "\(Date().offsetFrom(date: quitData!.quitDate))"
    }
    
    @IBAction func cravingButton(_ sender: Any) {
        let alertController = UIAlertController(title: "Did you smoke?", message: "Be honest with yourself. If you smoked, we'll reset your quit date. Bin the packet and carry on with the good work.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Yes", style: .destructive) { action in
            let quitData: [String: Any] = ["smokedDaily": self.quitData!.smokedDaily, "costOf20": self.quitData!.costOf20, "quitDate": Date()]
            self.userDefaults.set(quitData, forKey: "quitData")
            self.isQuitDateSet()
            let textField = alertController.textFields![0] as UITextField
            self.addCraving(catagory: (textField.text != nil) ? textField.text! : "", smoked: true)
            self.fetchCravingData()
        }
        alertController.addAction(cancelAction)
        let OKAction = UIAlertAction(title: "No", style: .default) { action in
            let textField = alertController.textFields![0] as UITextField
            self.addCraving(catagory: (textField.text != nil) ? textField.text! : "", smoked: false)
            self.fetchCravingData()
        }
        alertController.addAction(OKAction)
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter a mood or a situation"
        }
        self.present(alertController, animated: true) { }
    }
}

//Section 2 - Financial Info
extension MainVC {
    func setupSection2() {
        fetchSavingsGoalsData()
        populateScrollView()
    }
    
    func populateScrollView()  {
        let subViews = self.savingsScrollView.subviews
        for subview in subViews {
            subview.removeFromSuperview()
        }
        let scrollViewWidth:CGFloat = self.savingsScrollView.frame.width
        let scrollViewHeight:CGFloat = self.savingsScrollView.frame.height
        let myAttribute = [ NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.backgroundColor: UIColor.black, NSAttributedStringKey.font: UIFont(name: "AvenirNext-Bold", size: 30)!]
        var screenOneText = NSAttributedString()
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let formattedDailyCost = formatter.string(from: quitData!.costPerDay as NSNumber), let formattedAnnualCost = formatter.string(from: quitData!.costPerYear as NSNumber), let formattedSoFarSaving = formatter.string(from: quitData!.savedSoFar as NSNumber) {
            
            if (quitData?.quitDate)! < Date() {
                screenOneText = NSAttributedString(string: "\(formattedDailyCost) saved daily, \(formattedAnnualCost) saved yearly. \(formattedSoFarSaving) saved so far.", attributes: myAttribute)
            } else {
                screenOneText = NSAttributedString(string: "You're going to save \(formattedDailyCost) daily and \(formattedAnnualCost) yearly.", attributes: myAttribute)
            }
            
        }
        let screenOne = UITextView(frame: CGRect(x:0, y: scrollViewHeight / 3, width: scrollViewWidth, height: scrollViewHeight))
        screenOne.attributedText = screenOneText
        screenOne.backgroundColor = .clear
        screenOne.isEditable = false
        self.savingsScrollView.addSubview(screenOne)
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
            progress.animate(toAngle: progressAngle < 360 ? progressAngle : 360, duration: 1.5, completion: nil)
            self.savingsScrollView.addSubview(progress)
            let label = UILabel(frame: CGRect(x: (scrollViewWidth * CGFloat(x + 1) + (scrollViewWidth / 3)), y: scrollViewHeight / 2 ,width: scrollViewWidth - (scrollViewWidth / 3), height: 100))
            let string = NSAttributedString(string: savingsController.fetchedObjects![x].goalName!, attributes: myAttribute)
            label.attributedText = string
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.sizeToFit()
            progress.isUserInteractionEnabled = true
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
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = savingsScrollView.frame.width
        let currentPage:CGFloat = floor((savingsScrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.savingsPageControl.currentPage = Int(currentPage)
    }
    
    func fetchSavingsGoalsData() {
        //Fetching data on cravings.
        let fetchRequest: NSFetchRequest<SavingGoal> = SavingGoal.fetchRequest()
        let dateSort = NSSortDescriptor(key: "goalAmount", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        self.savingsController = controller
        do {
            try self.savingsController.performFetch()
            self.savingsPageControl.numberOfPages = self.savingsController.fetchedObjects?.count ?? 1
        } catch {
            let error = error as NSError
            print("\(error)")
        }
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
        //Fetching data on cravings.
        let fetchRequest: NSFetchRequest<Craving> = Craving.fetchRequest()
        let dateSort = NSSortDescriptor(key: "cravingDate", ascending: false)
        var cravingTriggerDictionary = [String:Int]()
        var cravingDateDictionary = [Date: Int]()
        var smoked = [Date: Int]()
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
                    smoked[standardisedDate!] = (smoked[standardisedDate!] == nil) ? 1 : smoked[standardisedDate!]! + 1
                }
            }
            displayCravingsData(dict: cravingDateDictionary, smoked: smoked, catagoryDict: cravingTriggerDictionary)
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    func displayCravingsData(dict: [Date: Int], smoked: [Date: Int], catagoryDict: [String: Int]) {
        let scrollViewHeight = cravingScrollView.bounds.height
        let scrollViewWidth = cravingScrollView.bounds.width
        let recentCravingsLineChart = CombinedChartView(frame: CGRect(x: 0, y: 0, width: scrollViewWidth - 10, height: scrollViewHeight))
        cravingScrollView.addSubview(recentCravingsLineChart)
        var referenceTimeInterval: TimeInterval = 0
        if let minTimeInterval = (dict.map { $0.key.timeIntervalSince1970 }).min() {
            referenceTimeInterval = minTimeInterval
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let xValuesNumberFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: formatter)
        let xAxis = recentCravingsLineChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelCount = dict.count
        xAxis.drawLabelsEnabled = true
        xAxis.drawLimitLinesBehindDataEnabled = true
        xAxis.avoidFirstLastClippingEnabled = true
        xAxis.valueFormatter = xValuesNumberFormatter
        var entries = [ChartDataEntry]()
        var smokedEntries = [BarChartDataEntry]()
        for x in dict {
            let timeInerval = x.key.timeIntervalSince1970
            let xValue = (timeInerval - referenceTimeInterval) / (3600 * 24)
            let yValue = x.value
            let smokedYValue = smoked[x.key]
            let entry = ChartDataEntry(x: xValue, y: Double(yValue))
            let smokedEntry = BarChartDataEntry(x: xValue, y: Double(smokedYValue!))
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
        barChartSet.colors = [UIColor.orange]
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
    
    func addCraving(catagory: String, smoked: Bool) {
        let craving = Craving(context: context)
        craving.cravingCatagory = catagory
        craving.cravingDate = Date()
        craving.cravingSmoked = smoked
        ad.saveContext()
        fetchCravingData()
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
        let scrollViewWidth: CGFloat = self.savingsScrollView.frame.width
        for (i,x) in healthStats {
            let label = UILabel(frame: CGRect(x: 0, y: int, width: Int(scrollViewWidth), height: 100))
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
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
