//
//  StateController.swift
//  Quit
//
//  Created by Alex Tudge on 16/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class StateController {
    
    // The path to the item's file in the documents directory
    static let itemsFilePath = NSSearchPathForDirectoriesInDomains(
        .DocumentDirectory, .UserDomainMask, true).first + "/items.txt"
    
    private(set) var items: [ToDoItem] = {

    }
    
    func addItem(item: ToDoItem) {
        
    }
    
    func save() {
        
    }
}
