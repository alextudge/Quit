//
//  QuitBaseViewController.swift
//  Quit
//
//  Created by Alex Tudge on 07/04/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import UIKit

class QuitBaseViewController: UIViewController {
    
    var persistenceManager: PersistenceManager?
    var quitData: QuitData? {
        return persistenceManager?.quitData
    }
    
    func presentQuitBaseViewController(_ viewController: QuitBaseViewController) {
        viewController.persistenceManager = persistenceManager
        present(viewController, animated: true, completion: nil)
    }
}
