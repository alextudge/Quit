//
//  CravingsViewController.swift
//  Quit
//
//  Created by Alex Tudge on 05/05/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import UIKit

class CravingsViewController: QuitBaseViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var cravings: [Craving]? {
        return persistenceManager?.getCravings()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(!isEditing, animated: true)
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
}

extension CravingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cravings?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CravingCell") as? CravingsCell,
            let craving = cravings?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.setup(craving)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete,
            let craving = cravings?[indexPath.row] {
            persistenceManager?.deleteObject(craving)
            NotificationCenter.default.post(Notification(name: Constants.InternalNotifs.cravingsChanged))
        }
        tableView.endEditing(true)
        tableView.reloadData()
    }
}
