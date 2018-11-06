//
//  SectionOneCarouselCell.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

protocol SectionOneCarouselCellDelegate: CanShowAlert {
    func didPressChangeQuitDate()
    func didPressSegueToSettings()
}

class SectionOneCarouselCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    
    var persistenceManager: PersistenceManager?
    
    weak var delegate: SectionOneCarouselCellDelegate?
    
    func setup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        registerCells()
        collectionView.reloadData()
    }
    
    private func registerCells() {
        collectionView.register(UINib(nibName: "SectionOneCravingDataCell", bundle: nil), forCellWithReuseIdentifier: "SectionOneCravingDataCell")
        collectionView.register(UINib(nibName: "SectionOneVapingDataCell", bundle: nil), forCellWithReuseIdentifier: "SectionOneVapingDataCell")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageController.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

extension SectionOneCarouselCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionOneCravingDataCell", for: indexPath) as? SectionOneCravingDataCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            cell.viewModel.persistenceManager = persistenceManager
            cell.setup()
            return cell
        } else if indexPath.row == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionOneVapingDataCell", for: indexPath) as? SectionOneVapingDataCell else {
                return UICollectionViewCell()
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3)
    }
}

extension SectionOneCarouselCell: SectionOneCravingDataCellDelegate {
    func didPressSegueToSettings() {
        delegate?.didPressSegueToSettings()
    }
    
    func didPressChangeQuitDate() {
        delegate?.didPressChangeQuitDate()
    }
    
    func presentAlert(_ alert: UIAlertController) {
        delegate?.presentAlert(alert)
    }
}
