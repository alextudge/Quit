//
//  QuitInfoPageViewController.swift
//  Quit
//
//  Created by Alex Tudge on 12/10/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import UIKit

class QuitInfoViewController: QuitBaseViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
}

private extension QuitInfoViewController {
    func setupDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension QuitInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuitInfoCostCell", for: indexPath) as? QuitInfoCostCell {
                cell.delegate = self
                cell.setup(persistenceManager: persistenceManager)
                return cell
            }
        case 1:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuitInfoDateCell", for: indexPath) as? QuitInfoDateCell {
                cell.delegate = self
                cell.setup(persistenceManager: persistenceManager)
                return cell
            }
        default:
            break
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}

extension QuitInfoViewController: QuitInfoCostCellDelegate {
    func goToNextPage() {
        collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension QuitInfoViewController: QuitInfoDateCellDelegate {
    func didFinishEnteringData() {
        dismiss(animated: true, completion: nil)
    }
}
