//
//  PersistenceManager.swift
//  Quit
//
//  Created by Alex Tudge on 16/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import CoreData
import Foundation

protocol PersistenceManagerProtocol {
    
    func setQuitDataInUserDefaults(object: [String: Any], key: String)
    func saveContext()
    func addCraving(catagory: String, smoked: Bool)
    func deleteObject(object: NSManagedObject)
    func deleteAllData()
    func addSavingGoal(title: String, cost: Double)
    
    var cravings: [Craving] { get }
    var savingsGoals: [SavingGoal] { get }
}

class PersistenceManager: NSObject, NSFetchedResultsControllerDelegate, PersistenceManagerProtocol {
    
    private var context: NSManagedObjectContext!
    private(set) var cravings = [Craving]()
    private(set) var savingsGoals = [SavingGoal]()
    private let objects = ["Craving", "SavingGoal"]
    private let userDefaults = UserDefaults.standard
    
    override init() {
        super.init()
        
        self.context = self.persistentContainer.viewContext
        //generateTestDate()
        fetchSavingsGoalsData()
        fetchCravingData()
    }
    
    //Persiting in userDefaults
    
    func setQuitDataInUserDefaults(object: [String: Any], key: String) {
        userDefaults.set(object, forKey: key)
    }
    
    //Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Quit")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //Craving model fucntions
    func addCraving(catagory: String, smoked: Bool) {
        let craving = Craving(context: context)
        craving.cravingCatagory = catagory.capitalized
        craving.cravingDate = Date()
        craving.cravingSmoked = smoked
        cravings.append(craving)
        saveContext()
    }
    
    func fetchCravingData() {
        let cravingFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Craving")
        let sort = NSSortDescriptor(key: "cravingDate", ascending: false)
        cravingFetch.sortDescriptors = [sort]
        do {
            cravings = (try context.fetch(cravingFetch) as? [Craving])!
        } catch {
            print("Failed to fetch cravings: \(error)")
        }
    }
    
    //Saving model functions
    func addSavingGoal(title: String, cost: Double) {
        let saving = SavingGoal(context: context)
        saving.goalName = title
        saving.goalAmount = cost
        savingsGoals.append(saving)
        saveContext()
    }
    
    func fetchSavingsGoalsData() {
        let savingsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SavingGoal")
        let sort = NSSortDescriptor(key: "goalAmount", ascending: true)
        savingsFetch.sortDescriptors = [sort]
        do {
            savingsGoals = (try context.fetch(savingsFetch) as? [SavingGoal])!
        } catch {
            print("Failed to fetch savings: \(error)")
        }
    }
    
    //Deletion functions
    func deleteObject(object: NSManagedObject) {
        context.delete(object)
        saveContext()
    }
    
    func deleteAllData() {
        for x in objects {
            let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: x))
            do {
                try context.execute(DelAllReqVar)
                savingsGoals = [SavingGoal]()
                cravings = [Craving]()
            } catch {
                print(error)
            }
        }
    }
    
    //Test data generator
    func generateTestDate() {
        var today = Date()
        for _ in 1...30 {
            let randomNumber = Int(arc4random_uniform(10))
            let randomBool = Int(arc4random_uniform(3))
            let tomorrow = Calendar.current.date(byAdding: .day, value: -1, to: today)
            let date = DateFormatter()
            date.dateFormat = "dd-MM-yyyy"
            let stringDate: String = date.string(from: today)
            today = tomorrow!
            for _ in 0...randomNumber {
                let craving = Craving(context: context)
                if randomBool == 0 {
                    craving.cravingCatagory = "Tired"
                } else if randomBool == 1 {
                    craving.cravingCatagory = "Alcohol"
                } else {
                    craving.cravingCatagory = "Stressed"
                }
                craving.cravingDate = date.date(from: stringDate)
                if randomBool == 0 {
                    craving.cravingSmoked = true
                } else {
                    craving.cravingSmoked = false
                }
            }
        }
        saveContext()
    }
}
