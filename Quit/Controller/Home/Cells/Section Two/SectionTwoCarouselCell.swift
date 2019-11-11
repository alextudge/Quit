//
//  SectionTwoCarouselCell.swift
//  Quit
//
//  Created by Alex Tudge on 04/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

protocol SectionTwoCarouselCellDelegate: class {
    func didTapSavingGoal(sender: SavingGoal?)
}

class SectionTwoCarouselCell: QuitBaseCarouselCollectionViewCell, QuitBaseCellProtocol {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageController: UIPageControl!
    
    var persistenceManager: PersistenceManager?
    
    weak var delegate: SectionTwoCarouselCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(notification:)), name: Constants.InternalNotifs.savingsChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(notification:)), name: Constants.InternalNotifs.quitDateChanged, object: nil)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func setup(peersistenceManager: PersistenceManager?) {
        self.persistenceManager = peersistenceManager
        pageController.numberOfPages = persistenceManager?.getGoals().count ?? 0 + 1
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageController.numberOfPages = persistenceManager?.getGoals().count ?? 0 + 1
        pageController.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

extension SectionTwoCarouselCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + (persistenceManager?.getGoals().count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionTwoSavingsOverviewCell", for: indexPath) as? SectionTwoSavingsOverviewCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            cell.persistenceManager = persistenceManager
            cell.setup()
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionTwoSavingsGoalCell", for: indexPath) as? SectionTwoSavingsGoalCell else {
                return UICollectionViewCell()
            }
            cell.persistenceManager = persistenceManager
            cell.savingGoal = persistenceManager?.getGoals()[indexPath.row - 1]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize(collectionView: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row != 0,
            let data = persistenceManager?.getGoals()[indexPath.row - 1] else {
                return
        }
        delegate?.didTapSavingGoal(sender: data)
    }
}

extension SectionTwoCarouselCell: SectionTwoSavingsOverviewCellDelegate {
    func didTapAddSavingsGoalButton() {
        delegate?.didTapSavingGoal(sender: nil)
    }
}

private extension SectionTwoCarouselCell {
    @objc func reloadData(notification: NSNotification) {
        pageController.numberOfPages = persistenceManager?.getGoals().count ?? 0 + 1
        collectionView.reloadData()
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "SectionTwoSavingsOverviewCell", bundle: nil), forCellWithReuseIdentifier: "SectionTwoSavingsOverviewCell")
        collectionView.register(UINib(nibName: "SectionTwoSavingsGoalCell", bundle: nil), forCellWithReuseIdentifier: "SectionTwoSavingsGoalCell")
        pageController.numberOfPages = persistenceManager?.getGoals().count ?? 0 + 1
    }
}
