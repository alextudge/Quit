//
//  AchievementsVC.swift
//  Quit
//
//  Created by Alex Tudge on 10/12/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

class AchievementsViewController: QuitBaseViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var viewModel: AchievementsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AchievementsViewModel(persistenceManager: persistenceManager)
        setupUI()
        setupTableView()
    }
}

private extension AchievementsViewController {
    func setupUI() {
        title = "Achievements"
    }
    
    func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension AchievementsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.achievements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.achievementCell, for: indexPath) as? AchievementCell else {
            return UITableViewCell()
        }
        cell.setupCell(data: viewModel.achievements[indexPath.row])
        return cell
    }
}
