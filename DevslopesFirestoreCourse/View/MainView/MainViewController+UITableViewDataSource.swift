//
//  MainViewController+UITableViewDataSource.swift
//  DevslopesFirestoreCourse
//
//  Created by Julian Worden on 8/6/22.
//

import Foundation
import UIKit

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thoughts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.postTableViewCellReuseId, for: indexPath)
        if let cell = cell as? PostTableViewCell {
            let thought = thoughts[indexPath.row]
            cell.configureCell(thought: thought, delegate: self)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
