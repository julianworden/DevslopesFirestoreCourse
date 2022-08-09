//
//  AddThoughtsViewController.swift
//  DevslopesFirestoreCourse
//
//  Created by Julian Worden on 8/5/22.
//

import Firebase
import UIKit

class AddThoughtViewController: UIViewController {
    lazy var contentStack = UIStackView(
        arrangedSubviews: [
            categorySelector,
            thoughtTextView,
            postButton
        ]
    )
    let categorySelector = UISegmentedControl()
    let thoughtTextView = UITextView()
    let postButton = RoundedButton(title: "Post", color: Constants.yellowColor)

    private var selectedCategory = ThoughtCategory.funny.rawValue

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        layoutViews()
    }

    func configureViews() {
        view.backgroundColor = .white

        contentStack.axis = .vertical
        contentStack.spacing = 10

        categorySelector.insertSegment(withTitle: "Funny", at: 0, animated: true)
        categorySelector.insertSegment(withTitle: "Serious", at: 1, animated: true)
        categorySelector.insertSegment(withTitle: "Crazy", at: 2, animated: true)
        categorySelector.selectedSegmentIndex = 0
        categorySelector.selectedSegmentTintColor = Constants.yellowColor
        categorySelector.backgroundColor = .clear
        categorySelector.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        categorySelector.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        categorySelector.addTarget(self, action: #selector(categorySelectorChanged), for: .valueChanged)

        thoughtTextView.font = UIFont(name: "Avenir Next", size: 14)
        thoughtTextView.backgroundColor = .lightGray.withAlphaComponent(0.25)
        thoughtTextView.layer.cornerRadius = 4
        thoughtTextView.text = "My random thought..."
        thoughtTextView.textColor = .lightGray
        thoughtTextView.delegate = self

        postButton.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
    }

    @objc func categorySelectorChanged() {
        switch categorySelector.selectedSegmentIndex {
        case 0:
            selectedCategory = ThoughtCategory.funny.rawValue
        case 1:
            selectedCategory = ThoughtCategory.serious.rawValue
        case 2:
            selectedCategory = ThoughtCategory.crazy.rawValue
        default:
            return
        }
    }

    @objc func postButtonTapped() {
        guard let currentUser = Auth.auth().currentUser else { return }
        guard thoughtTextView.text != "My random thought..." || thoughtTextView.text != "" else { return }

        Constants.thoughtsCollectionReference.addDocument(
            data: [
                Constants.fbCategory: selectedCategory,
                Constants.numberOfComments: 0,
                Constants.numberOfLikes: 0,
                Constants.fbThoughtText: thoughtTextView.text!,
                Constants.timestamp: FieldValue.serverTimestamp(),
                Constants.fbUsername: currentUser.displayName ?? "",
                Constants.fbUserId: currentUser.uid
            ]
        ) { [weak self] error in
            if let error = error {
                debugPrint("Error adding document: \(error)")
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension AddThoughtViewController {
    func layoutViews() {
        view.addSubview(contentStack)

        contentStack.translatesAutoresizingMaskIntoConstraints = false
        thoughtTextView.translatesAutoresizingMaskIntoConstraints = false
        postButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),

            thoughtTextView.heightAnchor.constraint(equalToConstant: 100),

            postButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
