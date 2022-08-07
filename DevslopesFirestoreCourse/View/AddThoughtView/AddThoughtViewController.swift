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
            usernameTextField,
            thoughtTextView,
            postButton
        ]
    )
    let categorySelector = UISegmentedControl()
    let usernameTextField = UITextField()
    let thoughtTextView = UITextView()
    let postButton = UIButton()

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
        contentStack.distribution = .fill

        categorySelector.insertSegment(withTitle: "Funny", at: 0, animated: true)
        categorySelector.insertSegment(withTitle: "Serious", at: 1, animated: true)
        categorySelector.insertSegment(withTitle: "Crazy", at: 2, animated: true)
        categorySelector.selectedSegmentIndex = 0
        categorySelector.selectedSegmentTintColor = Constants.yellowColor
        categorySelector.backgroundColor = .clear
        categorySelector.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        categorySelector.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        categorySelector.addTarget(self, action: #selector(categorySelectorChanged), for: .valueChanged)

        usernameTextField.font = UIFont(name: "Avenir Next", size: 14)
        usernameTextField.placeholder = "Username"

        thoughtTextView.font = UIFont(name: "Avenir Next", size: 14)
        thoughtTextView.backgroundColor = .lightGray.withAlphaComponent(0.25)
        thoughtTextView.layer.cornerRadius = 4
        thoughtTextView.text = "My random thought..."
        thoughtTextView.textColor = .lightGray
        thoughtTextView.delegate = self

        postButton.setTitle("Post", for: .normal)
        postButton.titleLabel?.font = UIFont(name: "Avenir Next Medium", size: 17)
        postButton.setTitleColor(.white, for: .normal)
        postButton.backgroundColor = Constants.yellowColor
        postButton.layer.cornerRadius = 4
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
        guard let usernameText = usernameTextField.text else { return }
        guard thoughtTextView.text != "My random thought..." || thoughtTextView.text != "" else { return }

        Firestore.firestore().collection(Constants.thoughtsCollection).addDocument(
            data: [
                Constants.category: selectedCategory,
                Constants.numberOfComments: 0,
                Constants.numberOfLikes: 0,
                Constants.thoughtText: thoughtTextView.text!,
                Constants.timestamp: FieldValue.serverTimestamp(),
                Constants.username: usernameText
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
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
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
