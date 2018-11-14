//
//  SectionThreeCarouselCell.swift
//  Quit
//
//  Created by Alex Tudge on 06/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class SectionThreeCarouselCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var persistenceManager: PersistenceManager?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadData(notification:)),
                                               name: Constants.InternalNotifs.cravingsChanged,
                                               object: nil)
        setupCollectionView()
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
            cell.persistenceManager = persistenceManager
            cell.reloadBarChart()
            return cell
        } else if indexPath.row == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionThreeTriggerChartCell", for: indexPath) as? SectionThreeTriggerChartCell else {
                return UICollectionViewCell()
            }
            cell.persistenceManager = persistenceManager
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2.3)
    }
}
