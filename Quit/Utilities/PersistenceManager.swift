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
    private lazy var persistentContainer: NSPersistentContainer = {
        generatePersistenceContainer()
    }()
    private let userDefaults = UserDefaults.init(suiteName: Constants.AppConfig.appGroupId)
    var interstitialAdCounter = 0
    
    override init() {
        super.init()
        context = persistentContainer.viewContext
        deleteOldCravings()
    }
    
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

// MARK: Fetching objects from coreData
extension PersistenceManager {
    func getProfile() -> Profile? {
        let profileRequest = NSFetchRequest<Profile>(entityName: Constants.CoreData.profile)
        do {
            return try context.fetch(profileRequest).first ?? generateProfile()
        } catch {
            return nil
        }
    }
    
    func getCravings() -> [Craving] {
        let cravingFetch = NSFetchRequest<Craving>(entityName: Constants.CoreData.craving)
        cravingFetch.predicate = NSPredicate(format: "(cravingDate >= %@)", thirtyDaysAgo())
        cravingFetch.sortDescriptors = [NSSortDescriptor(key: "cravingDate", ascending: false)]
        do {
            return try context.fetch(cravingFetch)
        } catch {
            return []
        }
    }
    
    func getTriggers() -> [String] {
        return Array(Set(getCravings().compactMap {
            $0.cravingCatagory
        })).sorted()
    }
    
    func getGoals() -> [SavingGoal] {
        let savingsFetch = NSFetchRequest<SavingGoal>(entityName: Constants.CoreData.savingGoal)
        savingsFetch.sortDescriptors = [NSSortDescriptor(key: "goalAmount", ascending: true)]
        do {
            return (try context.fetch(savingsFetch))
        } catch {
            return []
        }
    }
}

// MARK: Add objects to core data
extension PersistenceManager {
    func addCraving(catagory: String, smoked: Bool) {
        let craving = Craving(context: context)
        craving.cravingCatagory = catagory.capitalized
        craving.cravingDate = Date()
        craving.cravingSmoked = smoked
        saveContext()
    }
    
    func addSavingGoal(title: String, cost: Double) {
        let saving = SavingGoal(context: context)
        saving.goalName = title
        saving.goalAmount = cost
        saveContext()
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
        // swiftlint:disable:next line_length
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url:  FileManager.default.containerURL(forSecurityApplicationGroupIdentifier:  Constants.AppConfig.appGroupId)!.appendingPathComponent(Constants.CoreData.databaseId))]
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                print("\(error), \(error.userInfo)")
            }
        })
        return container
    }
    
    func generateProfile() -> Profile {
        let createdProfile = Profile(context: context)
        // MARK: This is for translating older users data into the newer core data format
        if let oldProfile = userDefaults?.object(forKey: Constants.UserDefaults.quitData) as? [String: Any] {
            if let smokedDaily = oldProfile[Constants.ProfileConstants.smokedDaily] as? Int16 {
                createdProfile.smokedDaily = NSNumber(value: smokedDaily)
            }
            if let costOf20 = oldProfile[Constants.ProfileConstants.costOf20] as? Double {
                createdProfile.costOf20 = NSNumber(value: costOf20)
            }
            if let quitDate = oldProfile[Constants.ProfileConstants.quitDate] as? Date {
                createdProfile.quitDate = quitDate
            }
            if let vapeSpending = oldProfile[Constants.ProfileConstants.vapeSpending] as? Double {
                createdProfile.vapeSpending = NSNumber(value: vapeSpending)
            }
        }
        if let returnedData = userDefaults?.object(forKey: Constants.UserDefaults.additionalUserData) as? [String: Any] {
            createdProfile.reasonsToSmoke = (returnedData[Constants.AdditionalUserDataConstants.reasonsToSmoke] as? [String]) as NSObject?
            createdProfile.reasonsToQuit = (returnedData[Constants.AdditionalUserDataConstants.reasonsNotToSmoke] as? [String]) as NSObject?
        }
        saveContext()
        return createdProfile
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
    
    func notifyOfCravingsChanges() {
        NotificationCenter.default.post(name: Constants.InternalNotifs.cravingsChanged, object: nil)
    }
    
    func notifyOfSavingsGoalChanges() {
        NotificationCenter.default.post(name: Constants.InternalNotifs.savingsChanged,
                                        object: nil)
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
