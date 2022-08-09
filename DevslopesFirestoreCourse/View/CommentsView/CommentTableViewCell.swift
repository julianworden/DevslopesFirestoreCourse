//
//  CommentsTableViewCell.swift
//  DevslopesFirestoreCourse
//
//  Created by Julian Worden on 8/7/22.
//

import Firebase
import UIKit

class CommentTableViewCell: UITableViewCell {
    lazy var contentStack = UIStackView(
        arrangedSubviews: [
            topLineStack,
            commentTextLabel
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
    let commentTextLabel = UILabel()

    private var comment: Comment!
    weak private var delegate: CommentDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureViews()
        layoutViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureViews() {
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

        commentTextLabel.font = UIFont(name: "Avenir Next Regular", size: 14)
        commentTextLabel.numberOfLines = 0
    }

    func configureCell(comment: Comment, delegate: CommentDelegate?) {
        usernameLabel.text = comment.username
        commentTextLabel.text = comment.commentText
        detailImageView.isHidden = true
        self.comment = comment
        self.delegate = delegate

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, hh:mm"
        let timestamp = dateFormatter.string(from: comment.timestamp.dateValue())
        timestampLabel.text = timestamp

        if comment.userId == Auth.auth().currentUser?.uid {
            detailImageView.isHidden = false
            detailImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(detailImageTapped))
            detailImageView.addGestureRecognizer(tap)
        }
    }

    @objc func detailImageTapped() {
        delegate?.commentCell(self, selectedDetailsForComment: comment)
    }
}

// MARK: - Constraints

extension CommentTableViewCell {
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
