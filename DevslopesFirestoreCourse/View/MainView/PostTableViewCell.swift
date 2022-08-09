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
            topLineStack,
            thoughtTextLabel,
            likesAndCommentsStack
        ]
    )
    lazy var topLineStack = UIStackView(
        arrangedSubviews: [
            usernameTimestampStack,
            detailImageView
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
    let detailImageView = UIImageView()
    let thoughtTextLabel = UILabel()
    lazy var likesAndCommentsStack = UIStackView(
        arrangedSubviews: [
            starImageView,
            numberOfLikesLabel,
            commentsImageView,
            numberOfCommentsLabel
        ]
    )
    let starImageView = UIImageView()
    let numberOfLikesLabel = UILabel()
    let commentsImageView = UIImageView()
    let numberOfCommentsLabel = UILabel()

    private var thought: Thought!
    weak private var delegate: PostDelegate?

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
        contentStack.spacing = 6
        contentStack.alignment = .leading

        topLineStack.axis = .horizontal

        usernameTimestampStack.axis = .horizontal
        usernameTimestampStack.spacing = 6

        usernameLabel.font = UIFont(name: "Avenir Next Medium", size: 17)
        usernameLabel.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)

        timestampLabel.font = UIFont(name: "Avenir Next Regular", size: 12)

        detailImageView.image = UIImage(named: "optionsImageDark")

        thoughtTextLabel.font = UIFont(name: "Avenir Next Regular", size: 14)
        thoughtTextLabel.numberOfLines = 0

        likesAndCommentsStack.axis = .horizontal
        likesAndCommentsStack.spacing = 6

        starImageView.image = UIImage(named: "starIconFilled")

        numberOfLikesLabel.font = UIFont(name: "Avenir Next Regular", size: 14)

        commentsImageView.image = UIImage(named: "commentIcon")

        numberOfCommentsLabel.font = UIFont(name: "Avenir Next Regular", size: 14)
    }

    func configureCell(thought: Thought, delegate: PostDelegate?) {
        detailImageView.isHidden = true
        self.thought = thought
        self.delegate = delegate
        usernameLabel.text = thought.username
        thoughtTextLabel.text = thought.thoughtText
        numberOfLikesLabel.text = String(thought.numberOfLikes)
        numberOfCommentsLabel.text = String(thought.numberOfComments)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, hh:mm"
        let timestamp = dateFormatter.string(from: thought.timestamp.dateValue())
        timestampLabel.text = timestamp

        if thought.userId == Auth.auth().currentUser?.uid {
            detailImageView.isHidden = false
            detailImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(detailImageTapped))
            detailImageView.addGestureRecognizer(tap)
        }
    }

    func configureGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        starImageView.addGestureRecognizer(tap)
        starImageView.isUserInteractionEnabled = true
    }

    @objc func detailImageTapped() {
        delegate?.postCell(self, selectedDetailsForThought: thought)
    }

    @objc func likeTapped() {
        Constants.thoughtsCollectionReference
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
        topLineStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),

            topLineStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            topLineStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
    }
}
