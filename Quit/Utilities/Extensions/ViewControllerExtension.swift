//
//  ViewControllerExtension.swift
//  Quit
//
//  Created by Alex Tudge on 25/06/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import UIKit

extension UIViewController {
    var isModal: Bool {
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
    
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
}
