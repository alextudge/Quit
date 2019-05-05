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
    
    private(set) var viewModel = HomeVCViewModel()
    
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
        largeTitlesEnabled = true
        title = "Quit"
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Settings"), style: .plain, target: self, action: #selector(segueToSettings))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func setupDelegates() {
        persistenceManager = PersistenceManager()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func handleQuitDataUI() {
        let quitDataAdded = quitData != nil
        tableView.isHidden = !quitDataAdded
        tableView.reloadData()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: Constants.Cells.sectionOneCarouselCell, bundle: nil),
                           forCellReuseIdentifier: Constants.Cells.sectionOneCarouselCell)
        tableView.register(UINib(nibName: Constants.Cells.sectionTwoCarouselCell, bundle: nil),
                           forCellReuseIdentifier: Constants.Cells.sectionTwoCarouselCell)
        tableView.register(UINib(nibName: Constants.Cells.sectionThreeCarouselCell, bundle: nil),
                           forCellReuseIdentifier: Constants.Cells.sectionThreeCarouselCell)
        tableView.register(UINib(nibName: Constants.Cells.sectionFourCarouselCell, bundle: nil),
                           forCellReuseIdentifier: Constants.Cells.sectionFourCarouselCell)
        tableView.register(UINib(nibName: Constants.Cells.sectionFiveCarouselCell, bundle: nil),
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

extension HomeViewController: SectionOneCarouselCellDelegate {
    func didPressSegueToAchievements() {
        segueToAchievementsVC()
    }
    
    func didPressChangeQuitDate() {
        segueToQuitDataViewController()
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
        if let viewController = ViewControllerFactory.SavingGoalVC.viewController() as? SavingGoalVC {
            viewController.persistenceManager = persistenceManager
            if let sender = sender {
                viewController.savingGoal = sender
            }
            viewController.delegate = self
            presentQuitBaseViewController(viewController)
        }
    }
}

extension HomeViewController: SectionFiveCarouselCellDelegate {
    func didTapEditButton(isReasonsToSmoke: Bool) {
        if let viewController = ViewControllerFactory.EditArrayVC.viewController() as? EditArrayVC {
            viewController.isReasonsToSmoke = isReasonsToSmoke
            viewController.persistenceManager = persistenceManager
            present(viewController, animated: true, completion: nil)
        }
    }
}

extension HomeViewController: ReasonsOnboardingVCDelegate {
    func didTapLetsGoButton() {
        didTapEditButton(isReasonsToSmoke: true)
    }
}

// MARK: Navigation
extension HomeViewController: AddCravingVCDelegate {
    func segueToQuitDataViewController() {
        if let viewController = ViewControllerFactory.QuitInfoVC.viewController() as? QuitInfoVC {
            viewController.persistenceManager = persistenceManager
            viewController.delegate = self
            presentQuitBaseViewController(viewController)
        }
    }
    
    func segueToSmokedVC() {
        if let viewController = ViewControllerFactory.SmokedVC.viewController() as? SmokedVC {
            present(viewController, animated: true, completion: nil)
        }
    }
    
    @objc private func segueToSettings() {
        if let viewController = ViewControllerFactory.SettingsVC.viewController() as? SettingsVC {
            viewController.persistenceManager = persistenceManager
            presentQuitBaseViewController(viewController)
        }
    }
    
    private func segueToAddCravingsVC() {
        if let viewController = ViewControllerFactory.AddCravingVC.viewController() as? AddCravingVC {
            viewController.persistenceManager = persistenceManager
            viewController.delegate = self
            presentQuitBaseViewController(viewController)
        }
    }
    
    private func segueToAchievementsVC() {
        if let viewController = ViewControllerFactory.AchievementsVC.viewController() as? AchievementsVC {
            viewController.persistenceManager = persistenceManager
            presentQuitBaseViewController(viewController)
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

extension HomeViewController: SectionThreeCarouselCellDelegate {
    func didTapCravingDetailsButton() {
        if let viewController = ViewControllerFactory.CravingsViewController.viewController() as? CravingsViewController {
            viewController.persistenceManager = persistenceManager
            presentQuitBaseViewController(viewController)
        }
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
            cell.delegate = self
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
        if section == 0 {
            return .leastNonzeroMagnitude
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.sizeForCellOf(type: indexPath.section)
    }
}
