//
//  HomeVC.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit
import GoogleMobileAds

class HomeViewController: QuitBaseViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var stackView: UIStackView!
    
    private(set) var viewModel = HomeVCViewModel()
    private var interstitial = GADInterstitial(adUnitID: Constants.AppConfig.adInterstitialId)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegates()
        setupTableView()
        showOnboarding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleQuitDataUI()
    }
    
    @IBAction private func didTapAddInfoButton(_ sender: Any) {
        segueToQuitDataViewController()
    }
}

private extension HomeViewController {
    func setupUI() {
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
        let image = UIImage(named: "Settings")?.withRenderingMode(.alwaysTemplate)
        let rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(segueToSettings))
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
        header.backgroundColor = .systemBackground
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.text = viewModel.titleForHeaderOf(section: section)
        header.addSubview(label)
        header.clipsToBounds = true
        return header
    }
    
    func showOnboarding() {
        let appLoadCount = persistenceManager?.appLoadCounter() ?? 1
        if appLoadCount % 3 != 0, persistenceManager?.isAdFree() == false {
            setupAd()
        }
    }
    
    func setupAd() {
        interstitial.delegate = self
        let request = GADRequest()
        interstitial.load(request)
    }
}

extension HomeViewController: GADInterstitialDelegate {
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        interstitial.present(fromRootViewController: self)
    }
}

extension HomeViewController: SectionOneCarouselCellDelegate, AddCravingVCDelegate {
    func didPressSegueToAchievements() {
        showViewController(type: .AchievementsVC)
    }
    
    func didPressChangeQuitDate() {
        segueToQuitDataViewController()
    }
    
    func segueToSmokedVC() {
        showViewController(type: .SmokedVC)
    }
    
    func addCraving() {
        if let viewController = ViewControllerFactory.AddCravingVC.viewController() as? AddCravingVC {
            viewController.delegate = self
            presentQuitBaseViewController(viewController)
        }
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
        showViewController(type: .CravingsViewController)
    }
}

extension HomeViewController: SectionFiveCarouselCellDelegate {
    func showViewController(type: ViewControllerFactory) {
        presentQuitBaseViewController(type.viewController()!)
    }
    
    func didTapEditButton(isReasonsToSmoke: Bool) {
        if let viewController = ViewControllerFactory.EditArrayVC.viewController() as? EditArrayVC {
            viewController.isReasonsToSmoke = isReasonsToSmoke
            presentQuitBaseViewController(viewController)
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

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var baseCell: HomeBaseCell?
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.sectionOneCarouselCell, for: indexPath) as? SectionOneCarouselCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            baseCell = cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.sectionTwoCarouselCell, for: indexPath) as? SectionTwoCarouselCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            baseCell = cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.sectionThreeCarouselCell, for: indexPath) as? SectionThreeCarouselCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            baseCell = cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.sectionFourCarouselCell, for: indexPath) as? SectionFourCarouselCell else {
                return UITableViewCell()
            }
            baseCell = cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.sectionFiveCarouselCell, for: indexPath) as? SectionFiveCarouselCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            baseCell = cell
        default:
            return UITableViewCell()
        }
        baseCell?.persistenceManager = persistenceManager
        return baseCell ?? UITableViewCell()
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
            viewController.delegate = self
            presentQuitBaseViewController(viewController)
        }
    }
    
    @objc func segueToSettings() {
        if let viewController = ViewControllerFactory.SettingsVC.viewController() as? SettingsVC {
            presentQuitBaseViewController(viewController)
        }
    }
    
    func segueToSavingsGoalVC(sender: SavingGoal?) {
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
