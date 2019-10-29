//
//  SectionOneCarouselCell.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

protocol SectionOneCarouselCellDelegate: class {
    func didPressChangeQuitDate()
    func didPressSegueToAchievements()
    func addCraving()
    func presentAlert(_ alert: UIAlertController)
}

class SectionOneCarouselCell: UICollectionViewCell, HomeBaseCellProtocol {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageController: UIPageControl!
    
    weak var delegate: SectionOneCarouselCellDelegate?
    
    var persistenceManager: PersistenceManager?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(notification:)), name: Constants.InternalNotifs.quitDateChanged, object: nil)
    }
}

extension SectionOneCarouselCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.sectionOneCravingDataCell, for: indexPath) as? SectionOneCravingDataCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            cell.viewModel.persistenceManager = persistenceManager
            cell.setup()
            return cell
        } else if indexPath.row == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.sectionOneVapingDataCell, for: indexPath) as? SectionOneVapingDataCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            cell.persistenceManager = persistenceManager
            cell.setup()
            return cell
        }
        return UICollectionViewCell()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageController.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

extension SectionOneCarouselCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2.3)
    }
}

extension SectionOneCarouselCell: SectionOneCellsDelegate {
    func didPressSegueToAchievements() {
        delegate?.didPressSegueToAchievements()
    }
    
    func addCraving() {
        delegate?.addCraving()
    }
    
    func didPressChangeQuitDate() {
        delegate?.didPressChangeQuitDate()
    }
    
    func presentAlert(_ alert: UIAlertController) {
        delegate?.presentAlert(alert)
    }
}

private extension SectionOneCarouselCell {
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SectionOneCravingDataCell", bundle: nil), forCellWithReuseIdentifier: "SectionOneCravingDataCell")
        collectionView.register(UINib(nibName: "SectionOneVapingDataCell", bundle: nil), forCellWithReuseIdentifier: "SectionOneVapingDataCell")
    }
    
    @objc func reloadData(notification: NSNotification) {
        collectionView.reloadData()
    }
}
