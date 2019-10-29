//
//  HomeBaseCell.swift
//  Quit
//
//  Created by Alex Tudge on 21/07/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import UIKit

protocol HomeBaseCellProtocol where Self: UICollectionViewCell {
    var persistenceManager: PersistenceManager? {get set}
}