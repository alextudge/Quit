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
    
    var controller: NSFetchedResultsController<Craving>!
    let userDefaults = UserDefaults.standard
    var quitData: QuitData? = nil
    @IBOutlet weak var quitDateLabel: UILabel!
    @IBOutlet weak var setQuitInformationButton: UIButton!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var overallSavingsLabel: UILabel!
    
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
        self.controller = controller
        do {
            try self.controller.performFetch()
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
}
