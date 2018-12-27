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
}

class SectionFiveCarouselCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var persistenceManager: PersistenceManager?
    
    weak var delegate: SectionFiveCarouselCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: Constants.Cells.sectionFiveReasonsToSmokeCell,
                                      bundle: nil),
                                forCellWithReuseIdentifier: Constants.Cells.sectionFiveReasonsToSmokeCell)
        collectionView.register(UINib(nibName: Constants.Cells.sectionFiveReasonsNotToSmokeCell,
                                      bundle: nil),forCellWithReuseIdentifier: Constants.Cells.sectionFiveReasonsNotToSmokeCell)
    }
}

extension SectionFiveCarouselCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
}

extension SectionFiveCarouselCell: SectionFiveReasonsToSmokeCellDelegate {
    func didTapEditButton(isReasonsToSmoke: Bool) {
        delegate?.didTapEditButton(isReasonsToSmoke: isReasonsToSmoke)
    }
}
