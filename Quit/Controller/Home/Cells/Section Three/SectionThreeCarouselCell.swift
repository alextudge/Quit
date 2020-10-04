//
//  SectionThreeCarouselCell.swift
//  Quit
//
//  Created by Alex Tudge on 06/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

protocol SectionThreeCarouselCellDelegate: class {
    func didTapCravingDetailsButton()
}

class SectionThreeCarouselCell: QuitBaseCarouselCollectionViewCell, QuitBaseCellProtocol {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageController: UIPageControl!
    
    var persistenceManager: PersistenceManager?
    
    weak var delegate: SectionThreeCarouselCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(notification:)), name: Constants.InternalNotifs.cravingsChanged, object: nil)
        setupCollectionView()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc private func reloadData(notification: NSNotification) {
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "SectionThreeCravingsChartCell", bundle: nil), forCellWithReuseIdentifier: "SectionThreeCravingsChartCell")
        collectionView.register(UINib(nibName: "SectionThreeTriggerChartCell", bundle: nil), forCellWithReuseIdentifier: "SectionThreeTriggerChartCell")
    }
}

extension SectionThreeCarouselCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionThreeCravingsChartCell", for: indexPath) as? SectionThreeCravingsChartCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            return cell
        } else if indexPath.row == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionThreeTriggerChartCell", for: indexPath) as? SectionThreeTriggerChartCell else {
                return UICollectionViewCell()
            }
            cell.setup(persistenceManager: persistenceManager)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize(collectionView: collectionView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
                pageController.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

extension SectionThreeCarouselCell: SectionThreeCravingsChartCellDelegate {
    func didTapCravingsDetailButton() {
        delegate?.didTapCravingDetailsButton()
    }
}
