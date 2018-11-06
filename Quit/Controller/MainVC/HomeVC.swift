//
//  HomeVC.swift
//  Quit
//
//  Created by Alex Tudge on 02/10/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = HomeVCViewModel()
    var quitData: QuitData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        tableView.delegate = self
        tableView.dataSource = self
        resetQuitData()
        tableView.reloadData()
        tableView.contentInset.top = view.safeAreaInsets.top
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if quitData == nil {
            performSegue(withIdentifier: "toQuitInfoVC", sender: nil)
        }
    }
    
    func resetQuitData() {
        quitData = viewModel.persistenceManager.getQuitDataFromUserDefaults()
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: "SectionOneCarouselCell", bundle: nil),  forCellReuseIdentifier: "SectionOneCarouselCell")
        tableView.register(UINib(nibName: "SectionTwoCarouselCell", bundle: nil), forCellReuseIdentifier: "SectionTwoCarouselCell")
        tableView.register(UINib(nibName: "SectionThreeCarouselCell", bundle: nil), forCellReuseIdentifier: "SectionThreeCarouselCell")
        tableView.register(UINib(nibName: "SectionFourCarouselCell", bundle: nil), forCellReuseIdentifier: "SectionFourCarouselCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQuitInfoVC" {
            if let destination = segue.destination as? QuitInfoVC {
                destination.delegate = self
                destination.quitData = quitData
                destination.persistenceManager = self.viewModel.persistenceManager
            }
        }
        if segue.identifier == "toSettingsVC" {
            if let destination = segue.destination as? SettingsVC {
                destination.delegate = self
                destination.persistenceManager = self.viewModel.persistenceManager
            }
        }
        if segue.identifier == "toSavingsGoalVC" {
            if let destination = segue.destination as? SavingGoalVC {
                destination.delegate = self
                destination.persistenceManager = self.viewModel.persistenceManager
                if let sender = sender as? SavingGoal {
                    destination.savingGoal = sender
                }
            }
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SectionOneCarouselCell", for: indexPath) as? SectionOneCarouselCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.persistenceManager = viewModel.persistenceManager
            cell.setup()
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTwoCarouselCell", for: indexPath) as? SectionTwoCarouselCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.persistenceManager = viewModel.persistenceManager
            cell.setupCell()
        } else if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SectionThreeCarouselCell", for: indexPath) as? SectionThreeCarouselCell else {
                return UITableViewCell()
            }
            cell.persistenceManager = viewModel.persistenceManager
            cell.setup()
        } else if indexPath.section == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SectionFourCarouselCell", for: indexPath) as? SectionFourCarouselCell else {
                return UITableViewCell()
            }
            cell.persistenceManager = viewModel.persistenceManager
            cell.setup()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 3
    }
    
    func segueToQuitDataVC() {
        performSegue(withIdentifier: "toQuitInfoVC", sender: nil)
    }
}

extension HomeVC: QuitDateSetVCDelegate {
    func reloadTableView() {
        tableView.reloadData()
    }
}

extension HomeVC: SectionOneCarouselCellDelegate {
    func didPressSegueToSettings() {
        performSegue(withIdentifier: "toSettingsVC", sender: nil)
    }
    
    func didPressChangeQuitDate() {
        performSegue(withIdentifier: "toQuitInfoVC", sender: nil)
    }
    
    func presentAlert(_ alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
}

extension HomeVC: SectionTwoCarouselCellDelegate {
    func didTapSavingGoal(sender: SavingGoal?) {
        performSegue(withIdentifier: "toSavingsGoalVC", sender: sender)
    }
}

extension HomeVC: SavingGoalVCDelegate {
    func setupSection2() {
        tableView.reloadData()
    }
}
