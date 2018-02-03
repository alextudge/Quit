//
//  ViewController.swift
//  Quit
//
//  Created by Alex Tudge on 02/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var controller: NSFetchedResultsController<Craving>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //generateTestData()
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
            //Printing returned objects as a test
            for object in controller.fetchedObjects! {
                print(object)
                print("\(object.cravingCatagory!)")
                print("\(object.cravingDate!)")
                print("\(object.cravingSmoked)")
            }
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    func generateTestData() {
        //Creating test data for the purposes of testing.
        let craving = Craving(context: context)
        craving.cravingCatagory = "Test"
        craving.cravingDate = Date()
        craving.cravingSmoked = false
        let craving1 = Craving(context: context)
        craving1.cravingCatagory = "Test1"
        craving1.cravingDate = Date()
        craving1.cravingSmoked = true
        let craving2 = Craving(context: context)
        craving2.cravingCatagory = "Test3"
        craving2.cravingDate = Date()
        craving2.cravingSmoked = false
        //Calling the universal function from the app delegate
        ad.saveContext()
    }
}

