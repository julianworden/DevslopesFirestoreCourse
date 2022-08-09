//
//  ViewController.swift
//  DevslopesFirestoreCourse
//
//  Created by Julian Worden on 8/4/22.
//

import Firebase
import UIKit

class MainViewController: UIViewController {
    let categorySelector = UISegmentedControl()
    let tableView = UITableView()

    var thoughts = [Thought]()
    private var selectedCategory = ThoughtCategory.funny.rawValue
    private var thoughtsListener: ListenerRegistration!
    private var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        layoutViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        handle = Auth.auth().addStateDidChangeListener({ [weak self] _, user in
            if user == nil {
                let loginViewController = LoginViewController()
                self?.present(loginViewController, animated: true)
            } else {
                self?.setThoughtsListener()
            }
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if thoughtsListener != nil {
            thoughtsListener.remove()
        }
    }

    func configureViews() {
        view.backgroundColor = .white
        title = "RNDM"
        let logOutButton = UIBarButtonItem(
            title: "Log Out",
            style: .plain,
            target: self,
            action: #selector(logOutTapped)
        )
        let addThoughtButton = UIBarButtonItem(
            image: UIImage(named: "addThoughtIcon"),
            style: .plain,
            target: self,
            action: #selector(addThoughtTapped)
        )
        navigationItem.leftBarButtonItem = logOutButton
        navigationItem.rightBarButtonItem = addThoughtButton

        categorySelector.insertSegment(withTitle: "Funny", at: 0, animated: true)
        categorySelector.insertSegment(withTitle: "Serious", at: 1, animated: true)
        categorySelector.insertSegment(withTitle: "Crazy", at: 2, animated: true)
        categorySelector.insertSegment(withTitle: "Popular", at: 3, animated: true)
        categorySelector.selectedSegmentIndex = 0
        categorySelector.selectedSegmentTintColor = Constants.yellowColor

        categorySelector.backgroundColor = .clear
        categorySelector.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        categorySelector.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        categorySelector.addTarget(self, action: #selector(categorySelectorChanged), for: .valueChanged)

        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: Constants.postTableViewCellReuseId)
        tableView.delegate = self
        tableView.dataSource = self
    }

    func setThoughtsListener() {
        if selectedCategory == ThoughtCategory.popular.rawValue {
            thoughtsListener = Constants.thoughtsCollectionReference
                .order(by: Constants.numberOfLikes, descending: true)
                .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    debugPrint("Error fetching documents: \(error)")
                } else {
                    self?.thoughts.removeAll()
                    self?.thoughts = Thought.parseData(snapshot: snapshot)
                    self?.tableView.reloadData()
                }
            }
        } else {
            thoughtsListener = Constants.thoughtsCollectionReference
                .whereField(Constants.category, isEqualTo: selectedCategory)
                .order(by: Constants.timestamp, descending: true)
                .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    debugPrint("Error fetching documents: \(error)")
                } else {
                    self?.thoughts.removeAll()
                    self?.thoughts = Thought.parseData(snapshot: snapshot)
                    self?.tableView.reloadData()
                }
            }
        }
    }

    @objc func logOutTapped() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch {
            debugPrint("Error signing out: \(error)")
        }
    }

    @objc func addThoughtTapped() {
        let addThoughtsViewController = AddThoughtViewController()
        navigationController?.pushViewController(addThoughtsViewController, animated: true)
    }

    @objc func categorySelectorChanged() {
        switch categorySelector.selectedSegmentIndex {
        case 0:
            selectedCategory = ThoughtCategory.funny.rawValue
        case 1:
            selectedCategory = ThoughtCategory.serious.rawValue
        case 2:
            selectedCategory = ThoughtCategory.crazy.rawValue
        case 3:
            selectedCategory = ThoughtCategory.popular.rawValue
        default:
            return
        }

        thoughtsListener.remove()
        setThoughtsListener()
    }
}

// MARK: - Constraints

extension MainViewController {
    func layoutViews() {
        view.addSubview(categorySelector)
        view.addSubview(tableView)

        categorySelector.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            categorySelector.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            categorySelector.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            categorySelector.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),

            tableView.topAnchor.constraint(equalTo: categorySelector.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
