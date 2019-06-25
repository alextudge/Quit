//
//  SectionFiveCarouselCell.swift
//  Quit
//
//  Created by Alex Tudge on 26/12/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

protocol SectionFiveCarouselCellDelegate: class {
    func didTapEditButton(isReasonsToSmoke: Bool)
    func showViewController(type: ViewControllerFactory)
}

class SectionFiveCarouselCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    
    var persistenceManager: PersistenceManager?
    
    weak var delegate: SectionFiveCarouselCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(notification:)), name: Constants.InternalNotifs.additionalDataUpdated, object: nil)
    }
    
    @objc private func reloadData(notification: NSNotification) {
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: Constants.Cells.sectionFiveReasonsToSmokeCell, bundle: nil), forCellWithReuseIdentifier: Constants.Cells.sectionFiveReasonsToSmokeCell)
        collectionView.register(UINib(nibName: Constants.Cells.sectionFiveReasonsNotToSmokeCell, bundle: nil),forCellWithReuseIdentifier: Constants.Cells.sectionFiveReasonsNotToSmokeCell)
        collectionView.register(UINib(nibName: "SectionFiveNotificationsCell", bundle: nil), forCellWithReuseIdentifier: "SectionFiveNotificationsCell")
    }
}

extension SectionFiveCarouselCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionFiveNotificationsCell", for: indexPath) as? SectionFiveNotificationsCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            return  cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.sectionFiveReasonsToSmokeCell, for: indexPath) as? SectionFiveReasonsToSmokeCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        cell.isReasonsToSmoke = indexPath.row == 0
        cell.setup(data: persistenceManager?.additionalUserData)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2.3)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageController.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

extension SectionFiveCarouselCell: SectionFiveReasonsToSmokeCellDelegate {
    func didTapEditButton(isReasonsToSmoke: Bool) {
        delegate?.didTapEditButton(isReasonsToSmoke: isReasonsToSmoke)
    }
}

extension SectionFiveCarouselCell: SectionFiveNotificationsCellDelegate {
    func showViewController(_ viewController: ViewControllerFactory) {
        delegate?.showViewController(type: viewController)
    }
}
