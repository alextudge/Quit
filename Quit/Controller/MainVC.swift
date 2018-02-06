//
//  MainVC.swift
//  Quit
//
//  Created by Alex Tudge on 02/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit
import CoreData
import Charts

//Set quit data if one doesnt already exist (pull it from NSUserDefaults or coreData?)
//Display 1. length of time since quit data, 2. craving chart over time, 3. money and target section, 4. health stats
//Create a feed of user posts about their quit experience
//Save local notifications periodically for continued interaction

class MainVC: UITableViewController, NSFetchedResultsControllerDelegate, QuitVCDelegate {
    
    var cravingController: NSFetchedResultsController<Craving>!
    var savingsController: NSFetchedResultsController<SavingGoal>!
    let userDefaults = UserDefaults.standard
    var quitData: QuitData? = nil
    @IBOutlet weak var quitDateLabel: UILabel!
    @IBOutlet weak var setQuitInformationButton: UIButton!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var overallSavingsLabel: UILabel!
    @IBOutlet weak var savingsScrollView: UIScrollView!
    @IBOutlet weak var savingsPageControl: UIPageControl!
    
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
            quitData = QuitData(smokedDaily: returnedData["smokedDaily"] as! Int, costOf20: returnedData["costOf20"] as! Int, quitDate: returnedData["quitDate"] as! Date)
            setupSection1()
            setupSection2()
        }
        setupSection3()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQuitInfoVC" {
            if let destination = segue.destination as? QuitInfoVC {
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
        generateSavingTestData()
        fetchSavingsGoalsData()
        populateScrollView()
    }
    
    func populateScrollView()  {
        let scrollViewWidth:CGFloat = self.savingsScrollView.frame.width
        let scrollViewHeight:CGFloat = self.savingsScrollView.frame.height
        let imgOne = UIImageView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgOne.image = UIImage(named: "Block")
        self.savingsScrollView.addSubview(imgOne)
        for x in 0..<savingsController.fetchedObjects!.count {
            let progress = KDCircularProgress(frame: CGRect(x: scrollViewWidth * CGFloat(x + 1), y: 0 ,width: scrollViewWidth, height: scrollViewHeight))
            progress.startAngle = -90
            progress.progressThickness = 0.2
            progress.trackThickness = 0.6
            progress.clockwise = true
            progress.gradientRotateSpeed = 2
            progress.roundedCorners = false
            progress.glowMode = .forward
            progress.glowAmount = 0.9
            progress.set(colors: UIColor.cyan ,UIColor.white, UIColor.magenta, UIColor.white, UIColor.orange)
            self.savingsScrollView.addSubview(progress)
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
        fetchRequest.sortDescriptors = [dateSort]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        self.cravingController = controller
        do {
            try self.cravingController.performFetch()
            for x in self.cravingController.fetchedObjects! {
                print(x)
            }
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    func addCraving(catagory: String, smoked: Bool) {
        let craving = Craving(context: context)
        craving.cravingCatagory = catagory
        craving.cravingDate = Date()
        craving.cravingSmoked = smoked
        ad.saveContext()
    }
    
    func generateSavingTestData() {
        let savingGoal = SavingGoal(context: context)
        savingGoal.goalAmount = 50.0
        savingGoal.goalName = "Test1"
        ad.saveContext()
    }
}
