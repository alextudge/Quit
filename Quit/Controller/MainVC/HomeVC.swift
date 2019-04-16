//
//  HomeVC.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class HomeVC: QuitBaseViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var statusBarViewHeight: NSLayoutConstraint!
    
    private(set) var viewModel = HomeVCViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        persistenceManager = PersistenceManager()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statusBarViewHeight.constant = UIApplication.shared.statusBarFrame.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if quitData == nil {
            segueToQuitDataVC()
            return
        }
        showOnboarding()
    }
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.sectionOneCarouselCell, for: indexPath) as? SectionOneCarouselCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.persistenceManager = persistenceManager
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.sectionTwoCarouselCell, for: indexPath) as? SectionTwoCarouselCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.persistenceManager = persistenceManager
            return cell
        } else if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.sectionThreeCarouselCell, for: indexPath) as? SectionThreeCarouselCell else {
                return UITableViewCell()
            }
            cell.persistenceManager = persistenceManager
            return cell
        } else if indexPath.section == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.sectionFourCarouselCell, for: indexPath) as? SectionFourCarouselCell else {
                return UITableViewCell()
            }
            cell.persistenceManager = persistenceManager
            return cell
        } else if indexPath.section == 4 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.sectionFiveCarouselCell, for: indexPath) as? SectionFiveCarouselCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.persistenceManager = persistenceManager
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerFor(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.sizeForCellOf(type: indexPath.section)
    }
}

extension HomeVC: SectionOneCarouselCellDelegate {
    func didPressSegueToAchievements() {
        segueToAchievementsVC()
    }
    
    func didPressSegueToSettings() {
        segueToSettings()
    }
    
    func didPressChangeQuitDate() {
        segueToQuitDataVC()
    }
    
    func addCraving() {
        segueToAddCravingsVC()
    }
    
    func presentAlert(_ alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
}

extension HomeVC: SectionTwoCarouselCellDelegate {
    func didTapSavingGoal(sender: SavingGoal?) {
        if let viewController = ViewControllerFactory.SavingGoalVC.viewController() as? SavingGoalVC {
            viewController.persistenceManager = persistenceManager
            if let sender = sender {
                viewController.savingGoal = sender
            }
            present(viewController, animated: true, completion: nil)
        }
    }
}

extension HomeVC: SectionFiveCarouselCellDelegate {
    func didTapEditButton(isReasonsToSmoke: Bool) {
        if let viewController = ViewControllerFactory.EditArrayVC.viewController() as? EditArrayVC {
            viewController.isReasonsToSmoke = isReasonsToSmoke
            viewController.persistenceManager = persistenceManager
            present(viewController, animated: true, completion: nil)
        }
    }
}

extension HomeVC: ReasonsOnboardingVCDelegate {
    func didTapLetsGoButton() {
        didTapEditButton(isReasonsToSmoke: true)
    }
}

private extension HomeVC {
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset.top = view.safeAreaInsets.top
        tableView.register(UINib(nibName: Constants.Cells.sectionOneCarouselCell,
                                 bundle: nil),
                           forCellReuseIdentifier: Constants.Cells.sectionOneCarouselCell)
        tableView.register(UINib(nibName: Constants.Cells.sectionTwoCarouselCell,
                                 bundle: nil),
                           forCellReuseIdentifier: Constants.Cells.sectionTwoCarouselCell)
        tableView.register(UINib(nibName: Constants.Cells.sectionThreeCarouselCell,
                                 bundle: nil),
                           forCellReuseIdentifier: Constants.Cells.sectionThreeCarouselCell)
        tableView.register(UINib(nibName: Constants.Cells.sectionFourCarouselCell,
                                 bundle: nil),
                           forCellReuseIdentifier: Constants.Cells.sectionFourCarouselCell)
        tableView.register(UINib(nibName: Constants.Cells.sectionFiveCarouselCell,
                                 bundle: nil),
                           forCellReuseIdentifier: Constants.Cells.sectionFiveCarouselCell)
    }
    
    func headerFor(section: Int) -> UIView {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        header.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        let label = UILabel(frame: CGRect(x: 15, y: 5, width: UIScreen.main.bounds.width - 40, height: 45))
        label.textColor = UIColor.darkGray.withAlphaComponent(0.9)
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.text = viewModel.titleForHeaderOf(section: section)
        header.addSubview(label)
        header.clipsToBounds = true
        return header
    }
    
    func showOnboarding() {
        let appLoadCount = persistenceManager?.appLoadCounter()
        if appLoadCount == 1 {
            showWidgetOnboarding()
        } else if appLoadCount ?? 0 >= 2,
            shouldShowReasonsOnboarding() {
            showReasonsOboarding()
        }
    }
    
    func shouldShowReasonsOnboarding() -> Bool {
        if persistenceManager?.hasSeenReasonsOnboarding() == false,
            persistenceManager?.additionalUserData?.reasonsToSmoke == nil {
            return true
        }
        return false
    }
}

// MARK: Navigation
extension HomeVC: AddCravingVCDelegate, SettingsVCDelegate {
    func segueToQuitDataVC() {
        if let viewController = ViewControllerFactory.QuitInfoVC.viewController() as? QuitInfoVC {
            viewController.persistenceManager = persistenceManager
            present(viewController, animated: true, completion: nil)
        }
    }
    
    func segueToSmokedVC() {
        if let viewController = ViewControllerFactory.SmokedVC.viewController() as? SmokedVC {
            present(viewController, animated: true, completion: nil)
        }
    }
    
    private func segueToSettings() {
        if let viewController = ViewControllerFactory.SettingsVC.viewController() as? SettingsVC {
            viewController.delegate = self
            viewController.persistenceManager = persistenceManager
            present(viewController, animated: true, completion: nil)
        }
    }
    
    private func segueToAddCravingsVC() {
        if let viewController = ViewControllerFactory.AddCravingVC.viewController() as? AddCravingVC {
            viewController.persistenceManager = persistenceManager
            viewController.delegate = self
            present(viewController, animated: true, completion: nil)
        }
    }
    
    private func segueToAchievementsVC() {
        if let viewController = ViewControllerFactory.AchievementsVC.viewController() as? AchievementsVC {
            viewController.persistenceManager = persistenceManager
            present(viewController, animated: true, completion: nil)
        }
    }
    
    //Onboarding
    private func showWidgetOnboarding() {
        if let viewController = ViewControllerFactory.WidgetOnboardingVC.viewController() as? WidgetOnboardingVC {
            present(viewController, animated: true, completion: nil)
        }
    }
    
    private func showReasonsOboarding() {
        if let viewController = ViewControllerFactory.ReasonsOnboardingVC.viewController() as? ReasonsOnboardingVC {
            viewController.delegate = self
            present(viewController, animated: true, completion: nil)
            persistenceManager?.setHasSeenReasonOnboarding()
        }
    }
}
