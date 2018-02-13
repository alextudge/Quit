//
//  SettingsVC.swift
//  Quit
//
//  Created by Alex Tudge on 12/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit
import CoreData

class SettingsVC: UIViewController {
    
    weak var delegate: QuitVCDelegate?
    let objects = ["Craving","SavingGoal"]
    @IBOutlet weak var deleteAllDataButton: UIButton!
    
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
        ad.saveContext()
        delegate?.isQuitDateSet()
    }
    
    @IBAction func goBackButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteAllDataButtonPressed(_ sender: Any) {
        self.deleteAllData()
    }
}

protocol settingsVCDelegate: class {
    func isQuitDateSet()
}
