//
//  QuitBaseCarouselCollectionViewCell.swift
//  Quit
//
//  Created by Alex Tudge on 10/11/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import UIKit

class QuitBaseCarouselCollectionViewCell: UICollectionViewCell {
    
    func cellSize(collectionView: UICollectionView) -> CGSize {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            let widthDivisionalFactor: CGFloat = UIDevice.current.isPortait ? 1 : 2
            return CGSize(width: collectionView.bounds.width / widthDivisionalFactor, height: collectionView.bounds.height)
        case .pad:
            return CGSize(width: collectionView.bounds.width / 2, height: collectionView.bounds.height)
        @unknown default:
            return .zero
        }
    }
}
