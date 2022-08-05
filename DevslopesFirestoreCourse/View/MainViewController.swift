//
//  ViewController.swift
//  DevslopesFirestoreCourse
//
//  Created by Julian Worden on 8/4/22.
//

import UIKit

class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        layoutViews()
    }

    func configureViews() {
        view.backgroundColor = .white
        title = "RNDM"
        let addThoughtButton = UIBarButtonItem(
            image: UIImage(named: "addThoughtIcon"),
            style: .plain,
            target: self,
            action: #selector(addThoughtTapped)
        )
//        addThoughtButton.tintColor = Constants.yellowColor

        navigationItem.rightBarButtonItem = addThoughtButton
    }

    @objc func addThoughtTapped() {
        let addThoughtsViewController = AddThoughtViewController()
        navigationController?.pushViewController(addThoughtsViewController, animated: true)
    }
}

// MARK: - Constraints

extension MainViewController {
    func layoutViews() {

    }
}
