//
//  QuitInfoPageViewController.swift
//  Quit
//
//  Created by Alex Tudge on 12/10/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import UIKit

class QuitInfoPageViewController: UIPageViewController {
    
private(set) var quitInfoViewControllers: [UIViewController] = {
        return [ViewControllerFactory.QuitCostViewController.viewController()!,
                ViewControllerFactory.QuitDateViewController.viewController()!]
    }()
    var persistenceManager: PersistenceManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        quitInfoViewControllers.forEach {
            guard let baseViewController = $0 as? QuitBaseViewController else {
                return
            }
            baseViewController.persistenceManager = persistenceManager
        }
        if let firstViewController = quitInfoViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension QuitInfoPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = quitInfoViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        guard quitInfoViewControllers.count > previousIndex else {
            return nil
        }
        return quitInfoViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = quitInfoViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = quitInfoViewControllers.count
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return quitInfoViewControllers[nextIndex]
    }
}

 extension UIPageViewController {
     func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
         if let currentViewController = viewControllers?[0] {
             if let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) {
                 setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
             }
         }
     }
 }
