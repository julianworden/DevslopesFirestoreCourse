//
//  PostTableViewCell.swift
//  DevslopesFirestoreCourse
//
//  Created by Julian Worden on 8/5/22.
//

import Firebase
import UIKit

class PostTableViewCell: UITableViewCell {
    lazy var contentStack = UIStackView(
        arrangedSubviews: [
            usernameTimestampStack,
            thoughtTextLabel,
            likesStack
        ]
    )
    lazy var usernameTimestampStack = UIStackView(
        arrangedSubviews: [
            usernameLabel,
            timestampLabel
        ]
    )
    let usernameLabel = UILabel()
    let timestampLabel = UILabel()
    let thoughtTextLabel = UILabel()
    lazy var likesStack = UIStackView(
        arrangedSubviews: [
            starImageView,
            numberOfLikesLabel
        ]
    )
    let starImageView = UIImageView()
    let numberOfLikesLabel = UILabel()

    private var thought: Thought!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureViews()
        layoutViews()
        configureGestureRecognizer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureViews() {
        contentView.backgroundColor = .white
        selectionStyle = .none

        contentStack.axis = .vertical
        contentStack.spacing = 4

        usernameTimestampStack.axis = .horizontal
        usernameTimestampStack.spacing = 6

        usernameLabel.font = UIFont(name: "Avenir Next Medium", size: 17)

        timestampLabel.font = UIFont(name: "Avenir Next Regular", size: 12)

        thoughtTextLabel.font = UIFont(name: "Avenir Next Regular", size: 14)
        thoughtTextLabel.numberOfLines = 0

        likesStack.axis = .horizontal
        likesStack.spacing = 6

        starImageView.image = UIImage(named: "starIconFilled")

        numberOfLikesLabel.font = UIFont(name: "Avenir Next Regular", size: 14)
    }

    func configureCell(thought: Thought) {
        self.thought = thought
        usernameLabel.text = thought.username
        thoughtTextLabel.text = thought.thoughtText
        numberOfLikesLabel.text = String(thought.numberOfLikes)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, hh:mm"
        let timestamp = dateFormatter.string(from: thought.timestamp.dateValue())
        timestampLabel.text = timestamp
    }

    func configureGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        starImageView.addGestureRecognizer(tap)
        starImageView.isUserInteractionEnabled = true
    }

    @objc func likeTapped() {
        Firestore.firestore()
            .collection(Constants.thoughtsCollection)
            .document(thought.documentId).setData(
                [
                    Constants.numberOfLikes: thought.numberOfLikes + 1
                ],
                merge: true
            )
    }
}

// MARK: - Constraints

extension PostTableViewCell {
    func layoutViews() {
        contentView.addSubview(contentStack)

        contentStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
    }
}
