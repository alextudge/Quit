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
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        generatePersistenceContainer()
    }()
    private let userDefaults = UserDefaults.init(suiteName: Constants.AppConfig.appGroupId)
    var interstitialAdCounter = 0
    private let storeOptions: [AnyHashable: Any] = [
      NSMigratePersistentStoresAutomaticallyOption: true,
      NSInferMappingModelAutomaticallyOption: true,
    ]
    
    override init() {
        super.init()
        context = persistentContainer.viewContext
        deleteOldCravings()
    }
    
    func addCraving(catagory: String, smoked: Bool) {
        let craving = Craving(context: context)
        craving.cravingDate = Date()
        craving.cravingCatagory = catagory
        craving.cravingSmoked = smoked
        do {
            try? context.save()
        }
    }
    
    func deleteEverything() {
        deleteAllObjects(Profile.self)
        deleteAllObjects(Craving.self)
        deleteAllObjects(SavingGoal.self)
        deleteAllObjects(VapeSpend.self)
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
}

private extension PersistenceManager {
    func generatePersistenceContainer() -> NSPersistentCloudKitContainer {
        let container = NSPersistentCloudKitContainer(name: Constants.AppConfig.appName)
        migrateIfRequired(container.persistentStoreCoordinator)
        let storeUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.AppConfig.appGroupId)!.appendingPathComponent(Constants.CoreData.databaseId)
        container.persistentStoreDescriptions.first?.url = storeUrl
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                print("\(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
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
    
    func migrateIfRequired(_ psc: NSPersistentStoreCoordinator) {
        let existingStoreUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.AppConfig.appGroupId)!.appendingPathComponent(Constants.CoreData.databaseId)
        if FileManager.default.fileExists(atPath: existingStoreUrl.path) {
            return
        }
        
        do {
            let store = try psc.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: existingStoreUrl,
                options: storeOptions)
            let newStore = try psc.migratePersistentStore(
                store,
                to: existingStoreUrl,
                options: [:],
                withType: NSSQLiteStoreType)
            try psc.remove(newStore)
        } catch {
            print("Error migrating store: \(error)")
        }
    }
    
    func getObjects<T: NSManagedObject>(_ type: T.Type) -> [T]? {
        let fetchRequest = NSFetchRequest<T>(entityName: NSStringFromClass(type))
        do {
            return try? self.context.fetch(fetchRequest)
        }
    }
    
    func deleteAllObjects<T: NSManagedObject>(_ type: T.Type) {
        getObjects(type)?.forEach {
            context.delete($0)
        }
        saveContext()
    }
}
