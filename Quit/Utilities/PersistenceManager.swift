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
    private let coreDataObjectNames = ["Craving", "SavingGoal"]
    private let userDefaults = UserDefaults.standard
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Quit")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    override init() {
        super.init()
        context = persistentContainer.viewContext
        fetchSavingsGoalsData()
        fetchCravingData()
        deleteOldCravings()
    }
    
    private func saveContext () {
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
        let cravingFetch = NSFetchRequest<Craving>(entityName: "Craving")
        let predicate = NSPredicate(format: "(cravingDate >= %@)", thirtyDaysAgo())
        let sort = NSSortDescriptor(key: "cravingDate", ascending: false)
        cravingFetch.predicate = predicate
        cravingFetch.sortDescriptors = [sort]
        do {
            cravings = try context.fetch(cravingFetch)
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
        let savingsFetch = NSFetchRequest<SavingGoal>(entityName: "SavingGoal")
        let sort = NSSortDescriptor(key: "goalAmount", ascending: true)
        savingsFetch.sortDescriptors = [sort]
        do {
            savingsGoals = (try context.fetch(savingsFetch))
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
        for object in coreDataObjectNames {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: object)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(batchDeleteRequest)
            } catch {
                print(error)
            }
        }
        savingsGoals = [SavingGoal]()
        cravings = [Craving]()
        saveContext()
    }
    
    func setQuitDataInUserDefaults(object: [String: Any], key: String) {
        userDefaults.set(object, forKey: key)
    }
}

private extension PersistenceManager {
    func thirtyDaysAgo() -> NSDate {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .day, value: -30, to: Date())! as NSDate
        return date
    }
    
    func deleteOldCravings() {
        let cravingFetch = NSFetchRequest<Craving>(entityName: "Craving")
        let predicate = NSPredicate(format: "(cravingDate < %@)", thirtyDaysAgo())
        let sort = NSSortDescriptor(key: "cravingDate", ascending: false)
        cravingFetch.predicate = predicate
        cravingFetch.sortDescriptors = [sort]
        do {
            cravings = try context.fetch(cravingFetch)
            cravings.forEach {
                context.delete($0)
            }
        } catch {
            print("Failed to fetch cravings: \(error)")
        }
    }
    
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
