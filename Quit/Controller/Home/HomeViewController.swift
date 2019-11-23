//
//  HomeVC.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import GoogleMobileAds

class HomeViewController: QuitBaseViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let viewModel = HomeViewModel()
    private let interstitial = GADInterstitial(adUnitID: Constants.AppConfig.adInterstitialId)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegates()
        setupTableView()
        startupOperations()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.frame = view.bounds
    }
    
    func startupOperations() {
        guard let profile = persistenceManager?.getProfile(),
            profile.quitDate != nil,
            profile.smokedDaily != nil,
            profile.costOf20 != nil else {
                segueToProfileViewController()
                return
        }
        showPendingStartupViews()
    }
}

private extension HomeViewController {
    func setupUI() {
        navigationController?.navigationBar.isHidden = true
    }
    
    func setupDelegates() {
        persistenceManager = PersistenceManager()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setupTableView() {
        collectionView.register(UINib(nibName: Constants.Cells.sectionOneCarouselCell, bundle: nil), forCellWithReuseIdentifier: Constants.Cells.sectionOneCarouselCell)
        collectionView.register(UINib(nibName: Constants.Cells.sectionTwoCarouselCell, bundle: nil), forCellWithReuseIdentifier: Constants.Cells.sectionTwoCarouselCell)
        collectionView.register(UINib(nibName: Constants.Cells.sectionThreeCarouselCell, bundle: nil), forCellWithReuseIdentifier: Constants.Cells.sectionThreeCarouselCell)
        collectionView.register(UINib(nibName: Constants.Cells.sectionFourCarouselCell, bundle: nil), forCellWithReuseIdentifier: Constants.Cells.sectionFourCarouselCell)
        collectionView.register(UINib(nibName: Constants.Cells.sectionFiveCarouselCell, bundle: nil), forCellWithReuseIdentifier: Constants.Cells.sectionFiveCarouselCell)
    }
    
    func showPendingStartupViews() {
        let appLoadCount = persistenceManager?.appLoadCounter() ?? 1
        if appLoadCount % 5 == 0, persistenceManager?.isAdFree() == false {
            setupAd()
        }
    }
    
    func setupAd() {
        interstitial.delegate = self
        interstitial.load(GADRequest())
    }
}

extension HomeViewController: GADInterstitialDelegate {
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        interstitial.present(fromRootViewController: self)
    }
}

extension HomeViewController: SectionOneCarouselCellDelegate, AddCravingViewControllerDelegate {
    func didTapSettings() {
        segueToSettings()
    }
    
    func didPressSegueToAchievements() {
        showViewController(type: .AchievementsVC)
    }
    
    func didPressChangeQuitDate() {
        segueToProfileViewController()
    }
    
    func segueToSmokedViewController() {
        showViewController(type: .SmokedVC)
    }
    
    func addCraving() {
        if let viewController = ViewControllerFactory.AddCravingVC.viewController() as? AddCravingViewController {
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

extension HomeViewController: SavingGoalVCDelegate {
    func reloadTableView() {
        collectionView.reloadData()
    }
}

extension HomeViewController: SectionFourCarouselCellDelegate {
    func loadHealthSummary(stat: HealthStats) {
        if let viewController = ViewControllerFactory.QuitHealthSummaryViewController.viewController() as? QuitHealthSummaryViewController {
            viewController.healthStat = stat
            presentQuitBaseViewController(viewController)
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var baseCell: QuitBaseCellProtocol?
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.sectionOneCarouselCell, for: indexPath) as? SectionOneCarouselCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            baseCell = cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.sectionTwoCarouselCell, for: indexPath) as? SectionTwoCarouselCell else {
                return UICollectionViewCell()
            }
            cell.setup(peersistenceManager: persistenceManager)
            cell.delegate = self
            baseCell = cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.sectionThreeCarouselCell, for: indexPath) as? SectionThreeCarouselCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            baseCell = cell
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.sectionFourCarouselCell, for: indexPath) as? SectionFourCarouselCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            baseCell = cell
        case 4:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.sectionFiveCarouselCell, for: indexPath) as? SectionFiveCarouselCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            baseCell = cell
        default:
            return UICollectionViewCell()
        }
        baseCell?.persistenceManager = persistenceManager
        return baseCell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            var heightDivisionalFactor: CGFloat = UIDevice.current.isPortait ? 2 : 1
            if indexPath.section == 3 {
                heightDivisionalFactor = 1.5
            }
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height / heightDivisionalFactor)
        case .pad:
            let heightDivisionalFactor: CGFloat = UIDevice.current.isPortait ? 3 : 2
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height / heightDivisionalFactor)
        @unknown default:
            return .zero
        }
    }
}

private extension HomeViewController {
    func segueToProfileViewController() {
        if let viewController = ViewControllerFactory.QuitInfoViewController.viewController() as? QuitInfoViewController {
            presentQuitBaseViewController(viewController, presentationStyle: .overFullScreen)
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
