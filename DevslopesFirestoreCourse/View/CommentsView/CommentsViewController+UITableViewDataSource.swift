//
//  CommentsViewController+UITableViewDataSource.swift
//  DevslopesFirestoreCourse
//
//  Created by Julian Worden on 8/7/22.
//

import Foundation
import UIKit

extension CommentsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.commentTableViewCellReuseId, for: indexPath)
        if let cell = cell as? CommentTableViewCell {
            let comment = comments[indexPath.row]
            cell.configureCell(comment: comment, delegate: self)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
