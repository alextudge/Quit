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
        return viewModel.persistenceManager.getQuitDataFromUserDefaults()
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.toQuitInfoVC {
            if let destination = segue.destination as? QuitInfoVC {
                destination.persistenceManager = viewModel.persistenceManager
            }
        }
        if segue.identifier == Constants.Segues.toSettingsVC {
            if let destination = segue.destination as? SettingsVC {
                destination.delegate = self
                destination.persistenceManager = viewModel.persistenceManager
            }
        }
        if segue.identifier == Constants.Segues.toSavingsGoalVC {
            if let destination = segue.destination as? SavingGoalVC {
                destination.persistenceManager = viewModel.persistenceManager
                if let sender = sender as? SavingGoal {
                    destination.savingGoal = sender
                }
            }
        }
        if segue.identifier == Constants.Segues.toAddCraving {
            if let destination = segue.destination as? AddCravingVC {
                destination.viewModel.persistenceManager = viewModel.persistenceManager
                destination.delegate = self
            }
        }
    }
    
    func segueToQuitDataVC() {
        performSegue(withIdentifier: Constants.Segues.toQuitInfoVC, sender: nil)
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
        if appLoadCount == 1 {
            performSegue(withIdentifier: Constants.Segues.toWidgetInformationVC, sender: nil)
        }
    }
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
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
        } else if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.sectionThreeCarouselCell, for: indexPath) as? SectionThreeCarouselCell else {
                return UITableViewCell()
            }
            cell.persistenceManager = viewModel.persistenceManager
        } else if indexPath.section == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.sectionFourCarouselCell, for: indexPath) as? SectionFourCarouselCell else {
                return UITableViewCell()
            }
            cell.persistenceManager = viewModel.persistenceManager
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
    func segueToSmokedVC() {
        performSegue(withIdentifier: Constants.Segues.toSmokedVC, sender: nil)
    }
    
    func didPressSegueToSettings() {
        performSegue(withIdentifier: Constants.Segues.toSettingsVC, sender: nil)
    }
    
    func didPressChangeQuitDate() {
        segueToQuitDataVC()
    }
    
    func presentAlert(_ alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    func addCraving() {
        performSegue(withIdentifier: Constants.Segues.toAddCraving, sender: nil)
    }
}

extension HomeVC: SectionTwoCarouselCellDelegate {
    func didTapSavingGoal(sender: SavingGoal?) {
        performSegue(withIdentifier: Constants.Segues.toSavingsGoalVC, sender: sender)
    }
}

extension HomeVC: AddCravingVCDelegate {
    
}

extension HomeVC: SettingsVCDelegate {}
