//
//  UpdateCommentViewController.swift
//  DevslopesFirestoreCourse
//
//  Created by Julian Worden on 8/9/22.
//

import Firebase
import UIKit

class UpdateCommentViewController: UIViewController {
    lazy var contentStack = UIStackView(arrangedSubviews: [commentTextView, updateButton])
    let commentTextView = UITextView()
    let updateButton = RoundedButton(title: "Update", color: Constants.yellowColor)

    var commentToEdit: Comment!
    var thoughtToEdit: Thought!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        layoutViews()
    }

    func configureViews() {
        view.backgroundColor = .white

        contentStack.axis = .vertical
        contentStack.spacing = 10
//
        commentTextView.text = commentToEdit.commentText
        commentTextView.font = UIFont(name: "Avenir Next", size: 14)
        commentTextView.backgroundColor = .lightGray.withAlphaComponent(0.20)
        commentTextView.layer.cornerRadius = 4
        commentTextView.textColor = .darkGray

        updateButton.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
    }

    @objc func updateButtonTapped() {
        guard let commentText = commentTextView.text else { return }

        Constants.thoughtsCollectionReference
            .document(thoughtToEdit.documentId)
            .collection(Constants.fbComments)
            .document(commentToEdit.documentId)
            .updateData([Constants.fbCommentText: commentText]) { [weak self] error in
                if let error = error {
                    debugPrint("Unable to update comment: \(error.localizedDescription)")
                } else {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
    }
}

// MARK: - Constraints

extension UpdateCommentViewController {
    func layoutViews() {
        view.addSubview(contentStack)

        contentStack.translatesAutoresizingMaskIntoConstraints = false
        commentTextView.translatesAutoresizingMaskIntoConstraints = false
        updateButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),

            commentTextView.heightAnchor.constraint(equalToConstant: 100),

            updateButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
