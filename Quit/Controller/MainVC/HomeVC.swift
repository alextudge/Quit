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
    
    private(set) var viewModel = HomeVCViewModel()
    private var quitData: QuitData? {
        return viewModel.persistenceManager.getQuitDataFromUserDefaults()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if quitData == nil {
            segueToQuitDataVC()
        }
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
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.toQuitInfoVC {
            if let destination = segue.destination as? QuitInfoVC {
                destination.delegate = self
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
                destination.delegate = self
                destination.persistenceManager = viewModel.persistenceManager
                if let sender = sender as? SavingGoal {
                    destination.savingGoal = sender
                }
            }
        }
    }
    
    func segueToQuitDataVC() {
        performSegue(withIdentifier: Constants.Segues.toQuitInfoVC, sender: nil)
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
            cell.setup()
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.sectionTwoCarouselCell, for: indexPath) as? SectionTwoCarouselCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.persistenceManager = viewModel.persistenceManager
            cell.setupCell()
        } else if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.sectionThreeCarouselCell, for: indexPath) as? SectionThreeCarouselCell else {
                return UITableViewCell()
            }
            cell.persistenceManager = viewModel.persistenceManager
            cell.setup()
        } else if indexPath.section == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.sectionFourCarouselCell, for: indexPath) as? SectionFourCarouselCell else {
                return UITableViewCell()
            }
            cell.persistenceManager = viewModel.persistenceManager
            cell.setup()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.section != 3 else {
            return UIScreen.main.bounds.height / 2
        }
        return UIScreen.main.bounds.height / 2.2
    }
}

extension HomeVC: QuitDateSetVCDelegate, SavingGoalVCDelegate {
    func reloadTableView(_ withSections: [Int]?) {
        guard let sectionsToReload = withSections else {
            tableView.reloadData()
            return
        }
        var indexSet = IndexSet()
        sectionsToReload.forEach {
            indexSet.insert($0)
        }
        tableView.reloadSections(indexSet, with: .automatic)
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
}

extension HomeVC: SectionTwoCarouselCellDelegate {
    func didTapSavingGoal(sender: SavingGoal?) {
        performSegue(withIdentifier: Constants.Segues.toSavingsGoalVC, sender: sender)
    }
}

extension HomeVC: SettingsVCDelegate {}
