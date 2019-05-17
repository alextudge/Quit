//
//  QuitTransitions.swift
//  Quit
//
//  Created by Alex Tudge on 18/05/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import Foundation

import UIKit

class QuitNavigationTransitions: NSObject, UINavigationControllerDelegate {
    
    private let expandingTransition = QuitAnimatedExpansionTransition()
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            guard let fromVC = fromVC as? QuitBaseViewController,
                let presentingView = fromVC.presentingView else {
                    return nil
            }
            expandingTransition.originFrame = fromVC.view.convert(presentingView.frame, to: fromVC.view)
            expandingTransition.presenting = true
            return expandingTransition
        } else {
            expandingTransition.presenting = false
            return expandingTransition
        }
    }
}
