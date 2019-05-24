//
//  HomeVC.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class HomeViewController: QuitBaseViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var stackView: UIStackView!
    
    private(set) var viewModel = HomeVCViewModel()
    private let navigationTransitionController = QuitNavigationTransitions()
    private var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegates()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleQuitDataUI()
        showOnboarding()
    }
    
    @IBAction private func didTapAddInfoButton(_ sender: Any) {
        segueToQuitDataViewController()
    }
}

private extension HomeViewController {
    func setupUI() {
        navigationController?.delegate = navigationTransitionController
        largeTitlesEnabled = true
        title = "Quit"
        setupSettingsNavButton()
    }
    
    func setupDelegates() {
        persistenceManager = PersistenceManager()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func handleQuitDataUI() {
        let quitDataAdded = quitData != nil
        tableView.isHidden = !quitDataAdded
        stackView.isHidden = quitDataAdded
        tableView.reloadData()
    }
    
    func setupSettingsNavButton() {
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Settings"), style: .plain, target: self, action: #selector(segueToSettings))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: Constants.Cells.sectionOneCarouselCell, bundle: nil), forCellReuseIdentifier: Constants.Cells.sectionOneCarouselCell)
        tableView.register(UINib(nibName: Constants.Cells.sectionTwoCarouselCell, bundle: nil), forCellReuseIdentifier: Constants.Cells.sectionTwoCarouselCell)
        tableView.register(UINib(nibName: Constants.Cells.sectionThreeCarouselCell, bundle: nil), forCellReuseIdentifier: Constants.Cells.sectionThreeCarouselCell)
        tableView.register(UINib(nibName: Constants.Cells.sectionFourCarouselCell, bundle: nil), forCellReuseIdentifier: Constants.Cells.sectionFourCarouselCell)
        tableView.register(UINib(nibName: Constants.Cells.sectionFiveCarouselCell, bundle: nil), forCellReuseIdentifier: Constants.Cells.sectionFiveCarouselCell)
    }
    
    func headerFor(section: Int) -> UIView {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50))
        let label = UILabel(frame: CGRect(x: 15, y: 5, width: screenWidth - 40, height: 45))
        header.backgroundColor = .white
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

extension HomeViewController: SectionOneCarouselCellDelegate, AddCravingVCDelegate {
    func didPressSegueToAchievements() {
        segueToAchievementsVC()
    }
    
    func didPressChangeQuitDate() {
        segueToQuitDataViewController()
    }
    
    func segueToSmokedVC() {
        segueToSmokedViewController()
    }
    
    func addCraving() {
        segueToAddCravingsVC()
    }
    
    func presentAlert(_ alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
}

extension HomeViewController: SectionTwoCarouselCellDelegate {
    func didTapSavingGoal(sender: SavingGoal?) {
        segueToSavingsGoalVC(sender: sender)
    }
}

extension HomeViewController: SectionThreeCarouselCellDelegate {
    func didTapCravingDetailsButton() {
        segueToEditCravingsViewController()
    }
}

extension HomeViewController: SectionFiveCarouselCellDelegate {
    func showViewController(type: ViewControllerFactory) {
        presentQuitBaseViewController(type.viewController()!)
    }
    
    func didTapEditButton(isReasonsToSmoke: Bool) {
        segueToReasons(isReasonsToSmoke: isReasonsToSmoke)
    }
}

extension HomeViewController: ReasonsOnboardingVCDelegate {
    func didTapLetsGoButton() {
        didTapEditButton(isReasonsToSmoke: true)
    }
}

extension HomeViewController: QuitInfoVCDelegate {
    func didUpdateQuitData() {
        handleQuitDataUI()
    }
}

extension HomeViewController: SavingGoalVCDelegate {
    func reloadTableView() {
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.sectionOneCarouselCell, for: indexPath) as? SectionOneCarouselCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.persistenceManager = persistenceManager
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.sectionTwoCarouselCell, for: indexPath) as? SectionTwoCarouselCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.persistenceManager = persistenceManager
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.sectionThreeCarouselCell, for: indexPath) as? SectionThreeCarouselCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.persistenceManager = persistenceManager
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.sectionFourCarouselCell, for: indexPath) as? SectionFourCarouselCell else {
                return UITableViewCell()
            }
            cell.persistenceManager = persistenceManager
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.sectionFiveCarouselCell, for: indexPath) as? SectionFiveCarouselCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.persistenceManager = persistenceManager
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerFor(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return .leastNonzeroMagnitude
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.sizeForCellOf(type: indexPath.section)
    }
}

private extension HomeViewController {
    func segueToQuitDataViewController() {
        if let viewController = ViewControllerFactory.QuitInfoVC.viewController() as? QuitInfoVC {
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) {
                presentingView = cell
            }
            viewController.persistenceManager = persistenceManager
            viewController.delegate = self
            presentQuitBaseViewController(viewController)
        }
    }
    
    func segueToSmokedViewController() {
        if let viewController = ViewControllerFactory.SmokedVC.viewController() as? SmokedVC {
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) {
                presentingView = cell
            }
            present(viewController, animated: true, completion: nil)
        }
    }
    
    @objc func segueToSettings() {
        if let viewController = ViewControllerFactory.SettingsVC.viewController() as? SettingsVC {
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) {
                presentingView = cell
            }
            viewController.persistenceManager = persistenceManager
            presentQuitBaseViewController(viewController)
        }
    }
    
    func segueToAddCravingsVC() {
        if let viewController = ViewControllerFactory.AddCravingVC.viewController() as? AddCravingVC {
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) {
                presentingView = cell
            }
            viewController.persistenceManager = persistenceManager
            viewController.delegate = self
            presentQuitBaseViewController(viewController)
        }
    }
    
    func segueToAchievementsVC() {
        if let viewController = ViewControllerFactory.AchievementsVC.viewController() as? AchievementsVC {
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) {
                presentingView = cell
            }
            viewController.persistenceManager = persistenceManager
            presentQuitBaseViewController(viewController)
        }
    }
    
    func showWidgetOnboarding() {
        if let viewController = ViewControllerFactory.WidgetOnboardingVC.viewController() as? WidgetOnboardingVC {
            present(viewController, animated: true, completion: nil)
        }
    }
    
    func showReasonsOboarding() {
        if let viewController = ViewControllerFactory.ReasonsOnboardingVC.viewController() as? ReasonsOnboardingVC {
            viewController.delegate = self
            present(viewController, animated: true, completion: nil)
            persistenceManager?.setHasSeenReasonOnboarding()
        }
    }
    
    func segueToReasons(isReasonsToSmoke: Bool) {
        if let viewController = ViewControllerFactory.EditArrayVC.viewController() as? EditArrayVC {
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 4)) {
                presentingView = cell
            }
            viewController.isReasonsToSmoke = isReasonsToSmoke
            viewController.persistenceManager = persistenceManager
            presentQuitBaseViewController(viewController)
        }
    }
    
    func segueToSavingsGoalVC(sender: SavingGoal?) {
        if let viewController = ViewControllerFactory.SavingGoalVC.viewController() as? SavingGoalVC {
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) {
                presentingView = cell
            }
            viewController.persistenceManager = persistenceManager
            if let sender = sender {
                viewController.savingGoal = sender
            }
            viewController.delegate = self
            presentQuitBaseViewController(viewController)
        }
    }
    
    func segueToEditCravingsViewController() {
        if let viewController = ViewControllerFactory.CravingsViewController.viewController() as? CravingsViewController {
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) {
                presentingView = cell
            }
            viewController.persistenceManager = persistenceManager
            presentQuitBaseViewController(viewController)
        }
    }
}
