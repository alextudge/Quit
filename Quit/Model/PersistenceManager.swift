//
//  PersistenceManager.swift
//  Quit
//
//  Created by Alex Tudge on 16/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import Foundation
import CoreData

class PersistenceManager: NSObject, NSFetchedResultsControllerDelegate {
    
    private var context: NSManagedObjectContext!
    private(set) var cravings = [Craving]()
    private(set) var savingsGoals = [SavingGoal]()
    private let objects = ["Craving","SavingGoal"]
    
    override init() {
        super.init()
        self.context = self.persistentContainer.viewContext
        fetchSavingsGoalsData()
        fetchCravingData()
    }
    
    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Quit")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func addCraving(catagory: String, smoked: Bool) {
        let craving = Craving(context: context)
        craving.cravingCatagory = catagory.capitalized
        craving.cravingDate = Date()
        craving.cravingSmoked = smoked
        cravings.append(craving)
    }
    
    func fetchCravingData() {
        let cravingFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Craving")
        let sort = NSSortDescriptor(key: "cravingDate", ascending: false)
        cravingFetch.sortDescriptors = [sort]
        do {
            cravings = try context.fetch(cravingFetch) as! [Craving]
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
    
    func addSavingGoal(title: String, cost: Double) {
        let saving = SavingGoal(context: context)
        saving.goalName = title
        saving.goalAmount = cost
        savingsGoals.append(saving)
    }
    
    func fetchSavingsGoalsData() {
        let savingsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SavingGoal")
        let sort = NSSortDescriptor(key: "goalAmount", ascending: true)
        savingsFetch.sortDescriptors = [sort]
        do {
            savingsGoals = try context.fetch(savingsFetch) as! [SavingGoal]
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
    
    func deleteObject(object: NSManagedObject) {
        context.delete(object)
    }
    
    func deleteAllData() {
        for x in objects {
            let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: x))
            do {
                try context.execute(DelAllReqVar)
            }
            catch {
                print(error)
            }
        }
    }
}
