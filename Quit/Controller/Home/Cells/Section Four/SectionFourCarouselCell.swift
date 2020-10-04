//
//  SectionFourCarouselCell.swift
//  Quit
//
//  Created by Alex Tudge on 15/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

protocol SectionFourCarouselCellDelegate: class {
//    func loadHealthSummary(stat: HealthStats)
}

class SectionFourCarouselCell: UICollectionViewCell, QuitBaseCellProtocol {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var persistenceManager: PersistenceManager?
    
    weak var delegate: SectionFourCarouselCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadData(notification:)),
                                               name: Constants.InternalNotifs.quitDateChanged,
                                               object: nil)
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
        collectionView.register(UINib(nibName: "SectionFourHealthCell", bundle: nil), forCellWithReuseIdentifier: "SectionFourHealthCell")
    }
}

extension SectionFourCarouselCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionFourHealthCell", for: indexPath) as? SectionFourHealthCell else {
                return UICollectionViewCell()
        }
        cell.persistenceManager = persistenceManager
//        cell.setupCell(data: HealthStats.allCases[indexPath.row])
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let healthStat = HealthStats.allCases[indexPath.row]
//        delegate?.loadHealthSummary(stat: healthStat)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height / 1.75, height: (collectionView.frame.height / 2) - 2)
    }
}
