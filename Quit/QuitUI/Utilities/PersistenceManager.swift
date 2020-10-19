//
//  PersistenceManager.swift
//  Quit
//
//  Created by Alex Tudge on 16/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import CoreData

class PersistenceManager: NSObject {
    
    private var context: NSManagedObjectContext!
    lazy var persistentContainer: NSPersistentContainer = {
        generatePersistenceContainer()
    }()
    private let userDefaults = UserDefaults.init(suiteName: Constants.AppConfig.appGroupId)
    var interstitialAdCounter = 0
    
    override init() {
        super.init()
        context = persistentContainer.viewContext
        deleteOldCravings()
    }
}

extension PersistenceManager {
    func appLoadCounter() -> Int {
        if let appLoadCount = userDefaults?.integer(forKey: Constants.UserDefaults.appLoadCount) {
            userDefaults?.set(appLoadCount + 1, forKey: Constants.UserDefaults.appLoadCount)
            return appLoadCount
        } else {
            userDefaults?.set(1, forKey: Constants.UserDefaults.appLoadCount)
            return 0
        }
    }
    
    func isAdFree() -> Bool {
        if userDefaults?.bool(forKey: Constants.UserDefaults.adFreeExpirationDate) == true {
            return true
        }
        return false
        
    }
    
    func updateAdFreeDate(_ purchased: Bool) {
        userDefaults?.set(purchased, forKey: Constants.UserDefaults.adFreeExpirationDate)
    }
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("\(error), \(String(describing: error._userInfo))")
            }
        }
    }
}

// MARK: Deleting objects from core data
extension PersistenceManager {
    func deleteObject(_ object: NSManagedObject) {
        context.delete(object)
        saveContext()
    }
    
    func deleteAllData() {
        for object in Constants.CoreData.coreDataObjects {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: object)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(batchDeleteRequest)
                NotificationCenter.default.post(Notification(name: Constants.InternalNotifs.cravingsChanged))
                NotificationCenter.default.post(Notification(name: Constants.InternalNotifs.savingsChanged))
                NotificationCenter.default.post(Notification(name: Constants.InternalNotifs.quitDateChanged))
            } catch {
                print(error)
            }
        }
        saveContext()
    }
}

private extension PersistenceManager {
    func generatePersistenceContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: Constants.AppConfig.appName)
        let storeUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.AppConfig.appGroupId)!.appendingPathComponent(Constants.CoreData.databaseId)
        let description = NSPersistentStoreDescription()
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        description.url = storeUrl
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url:  FileManager.default.containerURL(forSecurityApplicationGroupIdentifier:  Constants.AppConfig.appGroupId)!.appendingPathComponent(Constants.CoreData.databaseId))]
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                print("\(error), \(error.userInfo)")
            }
        })
        return container
    }
    
    func deleteOldCravings() {
        let cravingFetch = NSFetchRequest<Craving>(entityName: Constants.CoreData.craving)
        cravingFetch.predicate = NSPredicate(format: "(cravingDate < %@)", thirtyDaysAgo())
        cravingFetch.sortDescriptors = [NSSortDescriptor(key: "cravingDate", ascending: false)]
        do {
            let oldCravings = try context.fetch(cravingFetch)
            oldCravings.forEach {
                deleteObject($0)
            }
        } catch {
            print("\(error)")
        }
    }
    
    func thirtyDaysAgo() -> NSDate {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .day, value: -30, to: Date())! as NSDate
        return date
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
