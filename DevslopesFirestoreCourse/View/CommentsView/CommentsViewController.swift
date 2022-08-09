//
//  CommentsViewController.swift
//  DevslopesFirestoreCourse
//
//  Created by Julian Worden on 8/7/22.
//

import Firebase
import UIKit

class CommentsViewController: UIViewController {
    let tableView = UITableView()
    let addCommentView = UIView()
    lazy var addCommentStack = UIStackView(arrangedSubviews: [commentTextField, addCommentButton])
    let commentTextField = UITextField()
    let addCommentButton = UIButton(type: .contactAdd)

    var thought: Thought!
    var thoughtReference: DocumentReference!
    var comments = [Comment]()
    var commentListener: ListenerRegistration!
    let firestore = Firestore.firestore()
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureThoughtReference()
        configureViews()
        layoutViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        commentListener = Constants.thoughtsCollectionReference
            .document(thought.documentId)
            .collection(Constants.fbComments)
            .order(by: Constants.timestamp, descending: true)
            .addSnapshotListener({ snapshot, error in
                guard let snapshot = snapshot else {
                    if let error = error {
                        debugPrint("Error fetching comments: \(error)")
                    }

                    return
                }

                self.comments.removeAll()
                self.comments = Comment.parseData(snapshot: snapshot)
                self.tableView.reloadData()
            })
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        commentListener.remove()
    }

    func configureViews() {
        view.backgroundColor = .white

        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: Constants.commentTableViewCellReuseId)
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension

        addCommentView.bindToKeyboard()

        addCommentStack.axis = .horizontal

        commentTextField.placeholder = "Add Comment..."

        addCommentButton.tintColor = .black
        addCommentButton.addTarget(self, action: #selector(addCommentTapped), for: .touchUpInside)
    }

    func configureThoughtReference() {
        thoughtReference = Constants.thoughtsCollectionReference.document(thought.documentId)

        if let username = Auth.auth().currentUser?.displayName {
            self.username = username
        }
    }

    @objc func addCommentTapped() {
        guard let commentText = commentTextField.text else { return }
        guard let currentUser = Auth.auth().currentUser else { return }

        firestore.runTransaction { transaction, _ in
            var thoughtDocument: DocumentSnapshot!

            do {
                try thoughtDocument = transaction.getDocument(
                    Constants.thoughtsCollectionReference
                        .document(self.thought.documentId)
                )
            } catch let error as NSError {
                debugPrint("Fetch error: \(error)")
                return nil
            }

            guard let oldNumComments = thoughtDocument.data()?[Constants.numberOfComments] as? Int else { return nil }
            transaction.updateData([Constants.numberOfComments: oldNumComments + 1], forDocument: self.thoughtReference)

            let newCommentReference = Constants.thoughtsCollectionReference
                .document(self.thought.documentId)
                .collection(Constants.fbComments)
                .document()

            transaction.setData(
                [
                    Constants.fbCommentText: commentText,
                    Constants.timestamp: FieldValue.serverTimestamp(),
                    Constants.fbUsername: self.username ?? "Anonymous",
                    Constants.fbDocumentId: newCommentReference.documentID,
                    Constants.fbUserId: currentUser.uid
                ],
                forDocument: newCommentReference
            )

            return nil
        } completion: {_, error in
            if let error = error {
                debugPrint("Transaction failed: \(error)")
            } else {
                self.commentTextField.text = ""
                self.commentTextField.resignFirstResponder()
            }
        }

    }
}

// MARK: - Constraints

extension CommentsViewController {
    func layoutViews() {
        view.addSubview(tableView)
        view.addSubview(addCommentView)
        addCommentView.addSubview(addCommentStack)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        addCommentView.translatesAutoresizingMaskIntoConstraints = false
        addCommentStack.translatesAutoresizingMaskIntoConstraints = false
        commentTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: addCommentView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

//            addCommentView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            addCommentView.heightAnchor.constraint(equalToConstant: 50),
            addCommentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addCommentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addCommentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            addCommentStack.centerYAnchor.constraint(equalTo: addCommentView.centerYAnchor),
            addCommentStack.leadingAnchor.constraint(equalTo: addCommentView.leadingAnchor, constant: 10),
            addCommentStack.trailingAnchor.constraint(equalTo: addCommentView.trailingAnchor, constant: -10),

            commentTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
