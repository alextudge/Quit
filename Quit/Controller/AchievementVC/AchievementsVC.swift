//
//  AchievementsVC.swift
//  Quit
//
//  Created by Alex Tudge on 10/12/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class AchievementsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var achievements = [Achievement]()
    private let viewModel = AchievementsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        achievements = viewModel.processAchievements()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func didTapCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension AchievementsVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return achievements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.achievementCell, for: indexPath) as? AchievementCell else {
            return UITableViewCell()
        }
        cell.setupCell(data: achievements[indexPath.row])
        return cell
    }
}
