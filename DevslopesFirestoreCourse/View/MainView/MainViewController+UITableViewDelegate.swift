//
//  MainViewController+UITableViewDelegate.swift
//  DevslopesFirestoreCourse
//
//  Created by Julian Worden on 8/6/22.
//

import Foundation
import UIKit

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let commentsViewController = CommentsViewController()
        commentsViewController.thought = thoughts[indexPath.row]
        navigationController?.pushViewController(commentsViewController, animated: true)
    }
}
