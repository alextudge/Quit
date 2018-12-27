//
//  HomeVC.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var statusBarViewHeight: NSLayoutConstraint!
    
    private(set) var viewModel = HomeVCViewModel()
    private var quitData: QuitData? {
        return viewModel.persistenceManager.quitData
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    private func setupTableView() {
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
    
    func segueToQuitDataVC() {
        if let viewController = ViewControllerFactory.viewController(for: .quitInfoVc) as? QuitInfoVC {
            viewController.persistenceManager = viewModel.persistenceManager
            present(viewController, animated: true, completion: nil)
        }
    }
    
    private func headerFor(section: Int) -> UIView {
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
    
    private func showOnboarding() {
        let appLoadCount = viewModel.persistenceManager.appLoadCounter()
        if appLoadCount == 1,
            let viewController = ViewControllerFactory.viewController(for: .widgetOnboardingVc) as? WidgetOnboardingVC {
            present(viewController, animated: true, completion: nil)
        }
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
            cell.persistenceManager = viewModel.persistenceManager
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.sectionTwoCarouselCell, for: indexPath) as? SectionTwoCarouselCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.persistenceManager = viewModel.persistenceManager
            return cell
        } else if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.sectionThreeCarouselCell, for: indexPath) as? SectionThreeCarouselCell else {
                return UITableViewCell()
            }
            cell.persistenceManager = viewModel.persistenceManager
            return cell
        } else if indexPath.section == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.sectionFourCarouselCell, for: indexPath) as? SectionFourCarouselCell else {
                return UITableViewCell()
            }
            cell.persistenceManager = viewModel.persistenceManager
            return cell
        } else if indexPath.section == 4 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.sectionFiveCarouselCell, for: indexPath) as? SectionFiveCarouselCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.persistenceManager = viewModel.persistenceManager
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
        if let viewController = ViewControllerFactory.viewController(for: .achievementsVc) as? AchievementsVC {
            present(viewController, animated: true, completion: nil)
        }
    }
    
    func segueToSmokedVC() {
        if let viewController = ViewControllerFactory.viewController(for: .smokedVc) as? SmokedVC {
            present(viewController, animated: true, completion: nil)
        }
    }
    
    func didPressSegueToSettings() {
        if let viewController = ViewControllerFactory.viewController(for: .settingsVc) as? SettingsVC {
            viewController.delegate = self
            viewController.persistenceManager = viewModel.persistenceManager
            present(viewController, animated: true, completion: nil)
        }
    }
    
    func didPressChangeQuitDate() {
        segueToQuitDataVC()
    }
    
    func presentAlert(_ alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    func addCraving() {
        if let viewController = ViewControllerFactory.viewController(for: .addCravingVc) as? AddCravingVC {
            viewController.viewModel.persistenceManager = viewModel.persistenceManager
            viewController.delegate = self
            present(viewController, animated: true, completion: nil)
        }
    }
}

extension HomeVC: SectionTwoCarouselCellDelegate {
    func didTapSavingGoal(sender: SavingGoal?) {
        if let viewController = ViewControllerFactory.viewController(for: .savingsGoalVc) as? SavingGoalVC {
            viewController.persistenceManager = viewModel.persistenceManager
            if let sender = sender {
                viewController.savingGoal = sender
            }
            present(viewController, animated: true, completion: nil)
        }
    }
}

extension HomeVC: SectionFiveCarouselCellDelegate {
    func didTapEditButton(isReasonsToSmoke: Bool) {
        if let viewController = ViewControllerFactory.viewController(for: .editArrayVC) as? EditArrayVC {
            viewController.isReasonsToSmoke = isReasonsToSmoke
            viewController.persistenceManager = viewModel.persistenceManager
            present(viewController, animated: true, completion: nil)
        }
    }
}

extension HomeVC: AddCravingVCDelegate, SettingsVCDelegate {}
