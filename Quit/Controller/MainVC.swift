//
//  MainVC.swift
//  Quit
//
//  Created by Alex Tudge on 02/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit
import CoreData

//Display 1. length of time since quit data, 2. craving chart over time, 3. money and target section, 4. health stats
//Create a feed of user posts about their quit experience
//Save local notifications periodically for continued interaction

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
    
    //Set up the UI assuming no quit date has been set
    override func viewDidLoad() {
        tableView.rowHeight = UIScreen.main.bounds.height / 2
        setQuitInformationButton.isHidden = false
        quitDateLabel.isHidden = true
        isQuitDateSet()
    }
    
    //If a quit date has been set, populate the UI
    func isQuitDateSet() {
        if let returnedData = userDefaults.object(forKey: "quitData") as? [String: Any] {
            quitData = QuitData(smokedDaily: returnedData["smokedDaily"] as! Int, costOf20: returnedData["costOf20"] as! Double, quitDate: returnedData["quitDate"] as! Date)
            setupSection1()
            setupSection2()
            setupSection3()
            setupSection4()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQuitInfoVC" {
            if let destination = segue.destination as? QuitInfoVC {
                destination.delegate = self
                print("delegation working")
            }
        }
        if segue.identifier == "toSavingGoalVC" {
            if let destination = segue.destination as? SavingGoalVC {
                destination.delegate = self
                print("delegation working")
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
        addCraving(catagory: "Just testing", smoked: true)
        fetchCravingData()
    }
    
    
}

//Section 2 - Financial Info
extension MainVC {
    func setupSection2() {
        fetchSavingsGoalsData()
        populateScrollView()
    }
    
    func populateScrollView()  {
        let scrollViewWidth:CGFloat = self.savingsScrollView.frame.width
        let scrollViewHeight:CGFloat = self.savingsScrollView.frame.height
        let myAttribute = [ NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.backgroundColor: UIColor.black, NSAttributedStringKey.font: UIFont(name: "AvenirNext-Bold", size: 30)!]
        let screenOneText = NSAttributedString(string: "£\(Int(quitData!.costPerDay)) saved daily, £\(Int(quitData!.costPerYear)) saved yearly. £\(Int(quitData!.savedSoFar)) saved so far.", attributes: myAttribute)
        let screenOne = UITextView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
        screenOne.attributedText = screenOneText
        screenOne.backgroundColor = .clear
        screenOne.isEditable = false
        self.savingsScrollView.addSubview(screenOne)
        for x in 0..<savingsController.fetchedObjects!.count {
            let progress = KDCircularProgress(frame: CGRect(x: scrollViewWidth * CGFloat(x + 1), y: 0 ,width: scrollViewWidth, height: scrollViewHeight))
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
            progress.animate(toAngle: (quitData!.savedSoFar / savingsController.fetchedObjects![x].goalAmount) * 360, duration: 1.5, completion: nil)
            self.savingsScrollView.addSubview(progress)
            let label = UILabel(frame: CGRect(x: (scrollViewWidth * CGFloat(x + 1) + (scrollViewWidth / 2)), y: scrollViewHeight / 2 ,width: scrollViewWidth, height: 40))
            let string = NSAttributedString(string: savingsController.fetchedObjects![x].goalName!, attributes: myAttribute)
            label.attributedText = string
            self.savingsScrollView.addSubview(label)
        }
        self.savingsScrollView.contentSize = CGSize(width:self.savingsScrollView.frame.width * CGFloat(1 + (savingsController.fetchedObjects?.count ?? 0)), height:self.savingsScrollView.frame.height)
        self.savingsScrollView.delegate = self
        self.savingsPageControl.currentPage = 0
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
            for x in self.savingsController.fetchedObjects! {
                print(x)
            }
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
        //Fetching data on cravings.
        let fetchRequest: NSFetchRequest<Craving> = Craving.fetchRequest()
        let dateSort = NSSortDescriptor(key: "cravingDate", ascending: false)
        var cravingTriggerDictionary = [String:Int]()
        fetchRequest.sortDescriptors = [dateSort]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        self.cravingController = controller
        do {
            try self.cravingController.performFetch()
            for x in self.cravingController.fetchedObjects! {
                if let catagory = x.cravingCatagory {
                    cravingTriggerDictionary[catagory] = (cravingTriggerDictionary[catagory] == nil) ? 1 : cravingTriggerDictionary[catagory]! + 1
                }
                displayTopCravingMood(dictionary: cravingTriggerDictionary)
            }
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    func displayTopCravingMood(dictionary: [String:Int]) {
        //TODO
    }
    
    func displayTopCravingTime() {
        //TODO
    }
    
    func addCraving(catagory: String, smoked: Bool) {
        let craving = Craving(context: context)
        craving.cravingCatagory = catagory
        craving.cravingDate = Date()
        craving.cravingSmoked = smoked
        ad.saveContext()
    }
}

//Section 4 - Health
extension MainVC {
    func setupSection4() {
        prepareHealthScrollView()
    }
    
    func prepareHealthScrollView() {
        let healthStats: [String: Double] = ["Blood pressure normal": 20, "Pulse rate normal": 20, "Nicotine down to 90%": 480, "Blood oxygen levels normal": 720, "Carbon monoxide levels normal": 720, "Nerve endings started to repair": 2880, "Smell and taste normal": 2880, "Fully nictone free": 4320, "Lung performace improving": 4320, "Worst withdrawal symptoms over": 4320, "Mouth and blood circulation normal": 14400, "Emotional trauma ended": 21600]
        let myAttribute = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.backgroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "AvenirNext-Bold", size: 30)!]
        //var healthTextViewText = ""
        var int = 0
        let scrollViewWidth:CGFloat = self.savingsScrollView.frame.width
        let scrollViewHeight:CGFloat = self.savingsScrollView.frame.height
        for (i,x) in healthStats {
            //healthTextViewText += "\(i) \(Int((quitData!.minuteSmokeFree/x) < 100 ? (quitData!.minuteSmokeFree/x) : 100))% \n\n"
            let label = UILabel(frame: CGRect(x: 0, y: int ,width: Int(scrollViewWidth), height: 50))
            let attString = NSAttributedString(string: "\(i) \(Int((quitData!.minuteSmokeFree/x) < 100 ? (quitData!.minuteSmokeFree/x) : 100))% \n\n", attributes: myAttribute)
            label.attributedText = attString
            self.healthScrollView.addSubview(label)
            int += 50
        }
        self.healthScrollView.contentSize = CGSize(width: scrollViewWidth, height: CGFloat(healthStats.count * 50))
        self.healthScrollView.delegate = self
//        let string = NSAttributedString(string: healthTextViewText, attributes: myAttribute)
//        healthTextView.backgroundColor = .clear
//        healthTextView.isEditable = false
//        healthTextView.isScrollEnabled = true
//        healthTextView.attributedText = string
    }
}
