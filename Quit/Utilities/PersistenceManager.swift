//
//  PersistenceManager.swift
//  Quit
//
//  Created by Alex Tudge on 16/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import CoreData

class PersistenceManager: NSObject {
    private(set) var cravings = [Craving]() {
        didSet {
            notifyOfCravingsChanges()
        }
    }
    private(set) var savingsGoals = [SavingGoal]() {
        didSet {
            notifyOfSavingsGoalChanges()
        }
    }
    var quitData: QuitData? {
        return getQuitDataFromUserDefaults()
    }
    var additionalUserData: AdditionalUserData? {
        return getAdditionalUserDataFromUserDefaults()
    }
    private(set) var triggers: [String]?
    private var context: NSManagedObjectContext!
    private let userDefaults = UserDefaults.init(suiteName: Constants.AppConfig.appGroupId)
    private let parser = QuitParser()
    var interstitialAdCounter = 0
    private lazy var persistentContainer: NSPersistentContainer = {
        generatePersistenceContainer()
    }()
    
    override init() {
        super.init()
        context = persistentContainer.viewContext
        deleteOldCravings()
        fetchSavingsGoalsData()
        fetchCravingData()
        reloadTriggers()
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
    
    func hasSeenReasonsOnboarding() -> Bool {
        if userDefaults?.bool(forKey: Constants.UserDefaults.reasonsOnboardingSeen) == false {
            return false
        }
        return true
    }
    
    func setHasSeenReasonOnboarding() {
        userDefaults?.set(true, forKey: Constants.UserDefaults.reasonsOnboardingSeen)
    }
    
    func addCraving(catagory: String, smoked: Bool) {
        let craving = Craving(context: context)
        craving.cravingCatagory = catagory.capitalized
        craving.cravingDate = Date()
        craving.cravingSmoked = smoked
        cravings.append(craving)
        saveContext()
        reloadTriggers()
    }
    
    func addSavingGoal(title: String, cost: Double) {
        let saving = SavingGoal(context: context)
        saving.goalName = title
        saving.goalAmount = cost
        savingsGoals.append(saving)
        saveContext()
    }
    
    func deleteSavingsGoal(_ goal: SavingGoal) {
        if let index = savingsGoals.firstIndex(of: goal) {
            savingsGoals.remove(at: index)
            context.delete(goal)
            saveContext()
        }
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
        savingsGoals.removeAll()
        cravings.removeAll()
    }
    
    func setQuitDataInUserDefaults(object: [String: Any], key: String) {
        userDefaults?.set(object, forKey: key)
        NotificationCenter.default.post(name: Constants.InternalNotifs.quitDateChanged, object: nil)
    }
    
    func setAdditionalParametersInUserDefaults(object: [String: Any]) {
        userDefaults?.set(object, forKey: Constants.UserDefaults.additionalUserData)
        NotificationCenter.default.post(name: Constants.InternalNotifs.additionalDataUpdated,
                                        object: nil)
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

private extension PersistenceManager {
    func generatePersistenceContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: Constants.AppConfig.appName)
        let storeUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.AppConfig.appGroupId)!.appendingPathComponent(Constants.CoreData.databaseId)
        let description = NSPersistentStoreDescription()
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        description.url = storeUrl
        // swiftlint:disable:next line_length
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url:  FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.AppConfig.appGroupId)!.appendingPathComponent(Constants.CoreData.databaseId))]
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                print("\(error), \(error.userInfo)")
            }
        })
        return container
    }
    
    func fetchCravingData() {
        let cravingFetch = NSFetchRequest<Craving>(entityName: Constants.CoreData.craving)
        cravingFetch.predicate = NSPredicate(format: "(cravingDate >= %@)", thirtyDaysAgo())
        cravingFetch.sortDescriptors = [NSSortDescriptor(key: "cravingDate", ascending: false)]
        do {
            cravings = try context.fetch(cravingFetch)
        } catch {
            print("\(error)")
        }
    }
    
    func fetchSavingsGoalsData() {
        let savingsFetch = NSFetchRequest<SavingGoal>(entityName: Constants.CoreData.savingGoal)
        savingsFetch.sortDescriptors = [NSSortDescriptor(key: "goalAmount", ascending: true)]
        do {
            savingsGoals = (try context.fetch(savingsFetch))
        } catch {
            print("\(error)")
        }
    }
    
    func deleteCraving(_ craving: Craving) {
        if let index = cravings.firstIndex(of: craving) {
            cravings.remove(at: index)
            context.delete(craving)
        }
    }
    
    func deleteOldCravings() {
        let cravingFetch = NSFetchRequest<Craving>(entityName: Constants.CoreData.craving)
        cravingFetch.predicate = NSPredicate(format: "(cravingDate < %@)", thirtyDaysAgo())
        cravingFetch.sortDescriptors = [NSSortDescriptor(key: "cravingDate", ascending: false)]
        do {
            let oldCravings = try context.fetch(cravingFetch)
            oldCravings.forEach {
                deleteCraving($0)
            }
        } catch {
            print("\(error)")
        }
    }
    
    func getQuitDataFromUserDefaults() -> QuitData? {
        if let returnedData = userDefaults?.object(forKey: Constants.UserDefaults.quitData) as? [String: Any] {
            return parser.parseQuitData(quitData: returnedData)
        }
        return nil
    }
    
    func getAdditionalUserDataFromUserDefaults() -> AdditionalUserData? {
        if let returnedData = userDefaults?.object(forKey: Constants.UserDefaults.additionalUserData) as? [String: Any] {
            return parser.parseAdditionalUserData(data: returnedData)
        }
        return nil
    }
    
    func notifyOfCravingsChanges() {
        NotificationCenter.default.post(name: Constants.InternalNotifs.cravingsChanged,
                                        object: nil)
    }
    
    func notifyOfSavingsGoalChanges() {
        NotificationCenter.default.post(name: Constants.InternalNotifs.savingsChanged,
                                        object: nil)
    }
    
    func reloadTriggers() {
        triggers = Array(Set(cravings.compactMap {
            $0.cravingCatagory
        })).sorted()
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
